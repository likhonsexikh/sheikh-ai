# Sheikh AI - GitHub Copilot Custom Instructions

## Project Overview

Sheikh AI is a general-purpose AI Agent system that supports running various tools and operations in a sandbox environment. The system enables intelligent dialogue, file operations, shell command execution, browser automation, and web search capabilities in isolated Docker containers.

### Core Capabilities
- **Session Management**: Multi-session conversation handling with MongoDB/Redis persistence
- **Sandbox Execution**: Isolated Docker environments for each task
- **Tool Integration**: Browser (Playwright), Shell, File, Search, and MCP tools
- **Real-time Streaming**: SSE-based streaming for live updates
- **VNC Visualization**: Remote desktop viewing via WebSocket
- **Authentication**: JWT-based auth with multiple providers (password, local, none)

## Architecture

### Overall Design Pattern
The project follows **Domain-Driven Design (DDD)** with clear separation of concerns:

```
┌─────────────┐      ┌──────────────┐      ┌──────────────┐
│   Frontend  │ ───> │   Backend    │ ───> │   Sandbox    │
│   (Vue 3)   │ <─── │   (FastAPI)  │ <─── │   (Docker)   │
└─────────────┘      └──────────────┘      └──────────────┘
     SSE/WS              DDD Layers           Tool APIs
```

### Backend Layer Structure

#### 1. **Domain Layer** (`app/domain/`)
Core business logic and domain models. This is the heart of the application.

- **models/**: Domain entities (Session, Message, Event, ToolResult, etc.)
- **services/**: Domain services including:
  - `agent_task_runner.py`: Main task execution logic
  - `agent_domain_service.py`: Agent orchestration
  - `agents/`: Agent implementations (planner, execution)
  - `tools/`: Tool implementations (browser, file, shell, search, mcp)
  - `flows/`: Workflow implementations (plan-act pattern)
- **external/**: Interfaces for external services (LLM, Sandbox, Browser, Search, etc.)
- **repositories/**: Data access interfaces

#### 2. **Application Layer** (`app/application/`)
Orchestrates domain logic and use cases.

- **services/**: Application services (agent_service, auth_service, file_service, etc.)
- **schemas/**: Request/response DTOs
- **errors/**: Application-level exceptions

#### 3. **Interface Layer** (`app/interfaces/`)
External system interfaces and API routes.

- **api/routes.py**: REST API endpoints definition

#### 4. **Infrastructure Layer** (`app/infrastructure/`)
Technical implementations of external interfaces (database, cache, HTTP clients, etc.).

### Frontend Structure (`frontend/src/`)

Built with **Vue 3 + TypeScript + Vite + TailwindCSS**

- **api/**: API client implementations
- **components/**: Vue components (ChatBox, FilePanel, ToolPanel, etc.)
- **composables/**: Vue composition functions
- **pages/**: Route pages
- **types/**: TypeScript type definitions
- **utils/**: Utility functions
- **locales/**: i18n translations (en, zh)

### Sandbox Structure (`sandbox/app/`)

FastAPI service running inside Docker container providing tool APIs.

- **api/**: API endpoints for tools (browser, file, shell)
- **services/**: Tool service implementations
- **models/**: Data models
- **core/**: Core configurations

## Technology Stack

### Backend
- **Framework**: FastAPI (Python 3.9+)
- **LLM Integration**: OpenAI SDK (compatible with multiple providers)
- **Browser Automation**: Playwright
- **Async Runtime**: asyncio with async/await patterns
- **Database**: MongoDB (with Beanie ODM) + Redis (caching/queue)
- **Container Management**: Docker SDK for Python
- **Streaming**: SSE (Server-Sent Events) via sse-starlette
- **Authentication**: JWT with PyJWT
- **External Tools**: MCP (Model Context Protocol) v1.9+

### Frontend
- **Framework**: Vue 3 with Composition API
- **Language**: TypeScript
- **Build Tool**: Vite
- **Styling**: TailwindCSS + tw-animate-css
- **UI Components**: Reka UI (headless components)
- **Icons**: Lucide Vue Next
- **Code Editor**: Monaco Editor
- **VNC Client**: noVNC for remote desktop
- **HTTP Client**: Axios with fetch-event-source for SSE
- **State Management**: Vue's reactive system + Pinia (if needed)
- **i18n**: Vue I18n

### DevOps
- **Containerization**: Docker + Docker Compose
- **CI/CD**: GitHub Actions
- **Development**: Hot reload for both frontend and backend

## Coding Standards & Conventions

### Python Backend

#### 1. **Code Style**
- Follow PEP 8 style guide
- Use type hints for all function signatures
- Maximum line length: 100 characters (flexible for readability)
- Use async/await for all I/O operations

```python
async def create_session(
    self,
    user_id: str,
    agent_id: Optional[str] = None
) -> Session:
    """Create a new session with proper type hints."""
    pass
```

#### 2. **Naming Conventions**
- **Classes**: PascalCase (e.g., `AgentTaskRunner`, `SessionRepository`)
- **Functions/Methods**: snake_case (e.g., `create_session`, `process_message`)
- **Constants**: UPPER_SNAKE_CASE (e.g., `MAX_TOKENS`, `DEFAULT_TIMEOUT`)
- **Private members**: Prefix with underscore (e.g., `_session_id`)

#### 3. **Domain Model Patterns**
- Use Pydantic for all models (BaseModel for DTOs, Document for DB models)
- Keep domain models in `app/domain/models/`
- Separate DTOs (schemas) in `app/application/schemas/`

```python
from pydantic import BaseModel, Field
from typing import Optional

class SessionCreate(BaseModel):
    """DTO for session creation."""
    agent_id: Optional[str] = None
    title: Optional[str] = None
```

#### 4. **Error Handling**
- Create custom exceptions in `app/application/errors/`
- Use specific exception types for different error scenarios
- Always log errors with context

```python
from app.application.errors.exceptions import SessionNotFoundError

async def get_session(session_id: str) -> Session:
    session = await self._repository.find_by_id(session_id)
    if not session:
        raise SessionNotFoundError(f"Session {session_id} not found")
    return session
```

#### 5. **Dependency Injection**
- Use FastAPI's dependency injection system
- Define dependencies in `app/core/dependencies.py`
- Inject interfaces, not implementations

```python
from fastapi import Depends
from app.domain.external.llm import LLM

async def get_llm() -> LLM:
    return OpenAILLM(...)

@router.post("/chat")
async def chat(llm: LLM = Depends(get_llm)):
    pass
```

#### 6. **Async Best Practices**
- Always use `async/await` for I/O operations
- Use `asyncio.gather()` for concurrent operations
- Avoid blocking calls in async functions
- Use async context managers where appropriate

```python
async with self._session_lock(session_id):
    # Protected section
    pass
```

### TypeScript Frontend

#### 1. **Code Style**
- Use TypeScript strict mode
- Prefer `const` over `let`, avoid `var`
- Use arrow functions for callbacks
- Destructure objects and arrays when possible

```typescript
const handleSubmit = async (message: string): Promise<void> => {
  const { data } = await api.sendMessage(sessionId, message);
  // ...
}
```

#### 2. **Vue 3 Composition API**
- Use `<script setup>` syntax
- Group related refs and computed properties
- Extract reusable logic into composables

```vue
<script setup lang="ts">
import { ref, computed } from 'vue'
import type { Session } from '@/types/session'

const sessions = ref<Session[]>([])
const activeSessions = computed(() => 
  sessions.value.filter(s => s.status === 'active')
)
</script>
```

#### 3. **Type Definitions**
- Define interfaces for all API responses
- Keep types in `src/types/`
- Use type imports with `import type`

```typescript
export interface Session {
  session_id: string
  title: string
  status: 'active' | 'stopped' | 'completed'
  created_at: number
}
```

#### 4. **Component Structure**
- Keep components focused and single-purpose
- Extract complex logic into composables
- Use props validation with TypeScript

```vue
<script setup lang="ts">
interface Props {
  sessionId: string
  readonly?: boolean
}

const props = withDefaults(defineProps<Props>(), {
  readonly: false
})
</script>
```

#### 5. **API Integration**
- Centralize API calls in `src/api/`
- Handle errors consistently
- Use type-safe responses

```typescript
export async function getSession(sessionId: string): Promise<Session> {
  const response = await client.get<ApiResponse<Session>>(
    `/sessions/${sessionId}`
  )
  return response.data.data
}
```

## Domain-Driven Design Principles

### 1. **Separation of Concerns**
- **Domain Layer**: Pure business logic, no infrastructure dependencies
- **Application Layer**: Use case orchestration
- **Infrastructure Layer**: External service implementations
- **Interface Layer**: API contracts and adapters

### 2. **Dependency Rule**
Dependencies should point inward:
```
Interface Layer ──> Application Layer ──> Domain Layer
Infrastructure Layer ──────────────────> Domain Layer
```

### 3. **Repository Pattern**
- Abstract data access behind repository interfaces
- Define interfaces in domain layer
- Implement in infrastructure layer

```python
# Domain layer: app/domain/repositories/session_repository.py
class SessionRepository(ABC):
    @abstractmethod
    async def save(self, session: Session) -> None:
        pass

# Infrastructure layer: app/infrastructure/repositories/mongo_session_repository.py
class MongoSessionRepository(SessionRepository):
    async def save(self, session: Session) -> None:
        await session.save()
```

### 4. **External Service Abstraction**
- Define interfaces for external services in `app/domain/external/`
- Keep implementations in infrastructure layer

## Key Workflows

### 1. **Session Creation Flow**
```
User Request → API Route → Application Service → Domain Service 
→ Sandbox Creation → Session Persistence → Response
```

### 2. **Message Processing Flow**
```
User Message → SSE Stream Start → AgentTaskRunner → PlanActFlow
→ Tool Execution → Event Streaming → SSE Stream End
```

### 3. **Tool Invocation Flow**
```
Agent → Tool Selection → Sandbox API Call → Tool Execution
→ Result Processing → Event Emission → UI Update
```

## Tool Development Guidelines

### Creating a New Tool

1. **Define Tool Interface** (`app/domain/services/tools/`)
```python
from app.domain.services.tools.base import BaseTool

class MyCustomTool(BaseTool):
    def get_name(self) -> str:
        return "my_custom_tool"
    
    async def execute(self, params: dict) -> ToolResult:
        # Implementation
        pass
```

2. **Register Tool** in `AgentTaskRunner`
3. **Add Tool Event Model** in `app/domain/models/event.py`
4. **Implement Sandbox API** (if needed) in `sandbox/app/api/`
5. **Update Frontend UI** to display tool results

### Available Tools

- **BrowserTool**: Web automation with Playwright
- **ShellTool**: Execute shell commands in sandbox
- **FileTool**: File read/write operations
- **SearchTool**: Web search (Google/Bing/Baidu)
- **MessageTool**: User interaction and confirmations
- **MCPTool**: MCP protocol tool integration

## Agent Development

### Agent Types

#### 1. **Planner Agent** (`app/domain/services/agents/planner.py`)
- Breaks down complex tasks into steps
- Creates execution plans
- Uses structured JSON output

#### 2. **Execution Agent** (`app/domain/services/agents/execution.py`)
- Executes individual steps
- Calls appropriate tools
- Reports progress

### PlanAct Flow Pattern

The system uses a Plan-Act workflow:
1. **Plan**: Decompose task into actionable steps
2. **Act**: Execute each step with appropriate tools
3. **Observe**: Collect results and update state
4. **Replan**: Adjust plan based on observations (if needed)

## Configuration Management

### Environment Variables

Always use environment variables for configuration. Define in `.env`:

```bash
# LLM Configuration
API_KEY=your_api_key
API_BASE=https://api.openai.com/v1
MODEL_NAME=gpt-4o

# Sandbox
SANDBOX_IMAGE=likhonsexikh/sheikh-ai-sandbox
SANDBOX_TTL_MINUTES=30

# Database
MONGODB_URI=mongodb://localhost:27017
REDIS_HOST=localhost
```

### Configuration Loading

Use Pydantic Settings for type-safe config:

```python
from pydantic_settings import BaseSettings

class Settings(BaseSettings):
    api_key: str
    api_base: str = "https://api.openai.com/v1"
    
    class Config:
        env_file = ".env"
```

## Testing Guidelines

### Backend Testing

```python
import pytest
from httpx import AsyncClient

@pytest.mark.asyncio
async def test_create_session(client: AsyncClient):
    response = await client.put("/api/v1/sessions")
    assert response.status_code == 200
    data = response.json()
    assert "session_id" in data["data"]
```

### Frontend Testing

```typescript
import { mount } from '@vue/test-utils'
import ChatBox from '@/components/ChatBox.vue'

describe('ChatBox', () => {
  it('sends message on submit', async () => {
    const wrapper = mount(ChatBox)
    // Test implementation
  })
})
```

## Common Patterns

### 1. **Event Streaming Pattern**

```python
async def stream_events() -> AsyncGenerator[BaseEvent, None]:
    async for event in self._process_task():
        yield event
    yield DoneEvent()
```

### 2. **Async Context Manager for Resources**

```python
class SandboxManager:
    async def __aenter__(self):
        await self._start()
        return self
    
    async def __aexit__(self, *args):
        await self._cleanup()
```

### 3. **Retry Pattern with Exponential Backoff**

```python
from tenacity import retry, stop_after_attempt, wait_exponential

@retry(
    stop=stop_after_attempt(3),
    wait=wait_exponential(multiplier=1, min=2, max=10)
)
async def call_llm(prompt: str) -> str:
    return await llm.complete(prompt)
```

## Security Considerations

1. **Sandbox Isolation**: Each session runs in isolated Docker container
2. **JWT Authentication**: Secure token-based auth with expiration
3. **Input Validation**: Validate all inputs with Pydantic
4. **CORS**: Configure allowed origins properly
5. **Environment Secrets**: Never commit API keys or secrets
6. **File Access**: Restrict file operations to sandbox workspace

## Performance Optimization

1. **Database Indexing**: Index frequently queried fields
2. **Redis Caching**: Cache session states and temporary data
3. **Connection Pooling**: Reuse HTTP connections
4. **Async Operations**: Use asyncio.gather() for concurrent tasks
5. **Lazy Loading**: Load resources only when needed
6. **Stream Processing**: Use SSE for large responses

## Docker & Deployment

### Development Setup

```bash
# Start all services
docker-compose -f docker-compose-development.yml up

# Backend only
cd backend && ./dev.sh

# Frontend only
cd frontend && npm run dev
```

### Production Deployment

```bash
# Build and start
./build.sh
docker-compose up -d
```

## MCP Integration

The system supports Model Context Protocol (MCP) for external tool integration.

### MCP Configuration

Create `mcp.json`:

```json
{
  "mcpServers": {
    "my-tool": {
      "command": "node",
      "args": ["path/to/tool/index.js"],
      "env": {
        "API_KEY": "your-key"
      }
    }
  }
}
```

### MCP Tool Usage

MCP tools are automatically discovered and made available to agents.

## Internationalization (i18n)

### Adding Translations

1. Add keys to `frontend/src/locales/en.json` and `zh.json`
2. Use in components:

```vue
<template>
  <h1>{{ t('welcome.title') }}</h1>
</template>

<script setup lang="ts">
import { useI18n } from 'vue-i18n'
const { t } = useI18n()
</script>
```

## Debugging Tips

### Backend Debugging

1. Set `LOG_LEVEL=DEBUG` in `.env`
2. Use Rich library for formatted logging
3. Check sandbox logs: `docker logs <sandbox-name>`

### Frontend Debugging

1. Use Vue DevTools browser extension
2. Enable source maps in development
3. Check network tab for SSE streams

## Common Issues & Solutions

### 1. **Sandbox Creation Fails**
- Ensure Docker daemon is running
- Check Docker socket permissions
- Verify network `sheikh-ai-network` exists

### 2. **SSE Connection Drops**
- Check nginx timeout settings
- Verify CORS configuration
- Monitor network connectivity

### 3. **MongoDB Connection Issues**
- Verify MongoDB is running
- Check connection string format
- Ensure database user has proper permissions

## Code Review Checklist

- [ ] Type hints for all function signatures (Python)
- [ ] TypeScript types for all props and states (Vue)
- [ ] Error handling with specific exceptions
- [ ] Async/await used correctly for I/O operations
- [ ] No hardcoded credentials or secrets
- [ ] Proper logging with context
- [ ] Tests for new functionality
- [ ] Documentation updated if needed
- [ ] DDD layer boundaries respected
- [ ] Resource cleanup in finally blocks or context managers

## Additional Resources

- **OpenAPI Docs**: http://localhost:8000/docs (when running)
- **Project Docs**: https://docs.sheikhAI.com
- **Official Site**: https://app.sheikhAI.com
- **GitHub Issues**: https://github.com/likhonsexikh/sheikh-ai/issues

---

**Last Updated**: 2025-11-19
**Maintainer**: Sheikh AI Development Team
