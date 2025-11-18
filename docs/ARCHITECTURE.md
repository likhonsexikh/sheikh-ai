# Sheikh AI Architecture Documentation

This document provides comprehensive visual documentation of Sheikh AI's architecture and workflows using Mermaid diagrams.

## Table of Contents
- [System Architecture](#system-architecture)
- [User Flow](#user-flow)
- [Authentication Flow](#authentication-flow)
- [Task Execution Flow](#task-execution-flow)
- [Deployment Architecture](#deployment-architecture)
- [Development Workflow](#development-workflow)

## System Architecture

### High-Level Architecture

```mermaid
graph TB
    subgraph "Client Layer"
        Web[Web Browser]
        Mobile[Mobile Browser]
    end
    
    subgraph "Frontend Layer"
        Vue[Vue 3 Frontend<br/>TypeScript + Composition API]
        NoVNC[NoVNC Component<br/>Browser Viewing]
    end
    
    subgraph "Backend Layer"
        API[FastAPI Backend<br/>Python 3.11+]
        Auth[Authentication<br/>JWT + OAuth]
        SSE[Server-Sent Events<br/>Real-time Updates]
    end
    
    subgraph "Agent Layer"
        PlanAct[PlanAct Agent<br/>Task Planning]
        ToolMgr[Tool Manager<br/>Tool Selection]
    end
    
    subgraph "Sandbox Environment"
        Docker[Docker Container<br/>Ubuntu + Chrome]
        VNC[VNC Server<br/>xvfb + x11vnc]
        Tools[Tools<br/>Browser/Shell/File]
        API_SB[Sandbox API<br/>FastAPI]
    end
    
    subgraph "Data Layer"
        MongoDB[(MongoDB<br/>Sessions & History)]
        Redis[(Redis<br/>Cache & Queue)]
    end
    
    subgraph "External Services"
        LLM[LLM Provider<br/>OpenAI/DeepSeek]
        Search[Search Engine<br/>Bing/Google]
    end
    
    Web --> Vue
    Mobile --> Vue
    Vue --> API
    Vue --> NoVNC
    
    API --> Auth
    API --> SSE
    API --> PlanAct
    
    PlanAct --> ToolMgr
    PlanAct --> LLM
    
    ToolMgr --> Tools
    ToolMgr --> Search
    
    API --> MongoDB
    API --> Redis
    
    Docker --> VNC
    Docker --> Tools
    Docker --> API_SB
    
    NoVNC -.WebSocket.-> VNC
    
    style Web fill:#e1f5ff
    style Vue fill:#42b883
    style API fill:#009688
    style PlanAct fill:#ff9800
    style Docker fill:#2496ed
    style MongoDB fill:#47a248
    style Redis fill:#dc382d
    style LLM fill:#10a37f
```

### Component Interaction

```mermaid
sequenceDiagram
    participant U as User
    participant F as Frontend
    participant B as Backend
    participant A as Agent
    participant S as Sandbox
    participant L as LLM
    participant D as Database
    
    U->>F: Initiate Conversation
    F->>B: POST /api/sessions/create
    
    B->>D: Create Session
    D-->>B: Session ID
    
    B->>S: Create Docker Container
    S-->>B: Container Info
    
    B-->>F: Session ID + WebSocket URL
    F-->>U: Ready to Chat
    
    U->>F: Send Message
    F->>B: POST /api/messages
    
    B->>A: Process Message
    A->>L: Analyze & Plan
    L-->>A: Task Plan
    
    loop Task Execution
        A->>A: Select Tool
        A->>S: Execute Tool
        S-->>A: Tool Result
        A->>L: Continue Planning
        L-->>A: Next Action
    end
    
    A->>B: Task Complete
    B->>D: Save History
    B->>F: SSE: Updates
    F->>U: Display Results
```

## User Flow

### Authentication & Session Management

```mermaid
flowchart TD
    Start([User Visits Site]) --> CheckAuth{Authenticated?}
    
    CheckAuth -->|No| LoginPage[Show Login Page]
    CheckAuth -->|Yes| Dashboard[Load Dashboard]
    
    LoginPage --> LoginType{Auth Type?}
    
    LoginType -->|Password| EmailPass[Email + Password]
    LoginType -->|Local| LocalAuth[Local Auth]
    LoginType -->|None| SkipAuth[Skip Authentication]
    
    EmailPass --> ValidatePass{Valid?}
    ValidatePass -->|No| LoginError[Show Error]
    ValidatePass -->|Yes| GenerateJWT[Generate JWT Token]
    
    LocalAuth --> ValidateLocal{Valid?}
    ValidateLocal -->|No| LoginError
    ValidateLocal -->|Yes| GenerateJWT
    
    SkipAuth --> Dashboard
    
    GenerateJWT --> SetCookie[Set HTTP-Only Cookie]
    SetCookie --> Dashboard
    
    LoginError --> LoginPage
    
    Dashboard --> CreateSession[Create Chat Session]
    CreateSession --> AllocSandbox[Allocate Sandbox]
    AllocSandbox --> ReadyChat[Ready for Chat]
    
    ReadyChat --> UserInput[User Sends Message]
    UserInput --> ProcessMsg[Process Message]
    ProcessMsg --> ShowResult[Display Results]
    ShowResult --> NextAction{Continue?}
    
    NextAction -->|Yes| UserInput
    NextAction -->|No| EndSession[End Session]
    
    EndSession --> CleanupSandbox[Cleanup Sandbox]
    CleanupSandbox --> End([Session Complete])
    
    style Start fill:#4caf50
    style Dashboard fill:#2196f3
    style GenerateJWT fill:#ff9800
    style AllocSandbox fill:#9c27b0
    style End fill:#f44336
```

## Authentication Flow

### JWT Authentication Process

```mermaid
sequenceDiagram
    participant C as Client
    participant F as Frontend
    participant B as Backend
    participant DB as Database
    participant JWT as JWT Service
    
    Note over C,JWT: Initial Login
    C->>F: Enter Credentials
    F->>B: POST /api/auth/login<br/>{email, password}
    
    B->>DB: Query User
    DB-->>B: User Data
    
    B->>B: Verify Password<br/>(bcrypt)
    
    alt Password Valid
        B->>JWT: Generate Tokens
        JWT-->>B: Access + Refresh Token
        B->>DB: Store Refresh Token
        B-->>F: {access_token, refresh_token}
        F->>F: Store in HTTP-Only Cookie
        F-->>C: Login Success
    else Password Invalid
        B-->>F: 401 Unauthorized
        F-->>C: Login Failed
    end
    
    Note over C,JWT: Authenticated Request
    C->>F: Make Request
    F->>B: API Request<br/>+ Access Token
    B->>JWT: Verify Token
    
    alt Token Valid
        JWT-->>B: User Info
        B->>B: Process Request
        B-->>F: Response
        F-->>C: Display Data
    else Token Expired
        B-->>F: 401 Token Expired
        F->>B: POST /api/auth/refresh<br/>+ Refresh Token
        B->>JWT: Verify Refresh Token
        B->>JWT: Generate New Access Token
        JWT-->>B: New Access Token
        B-->>F: {access_token}
        F->>F: Update Cookie
        F->>B: Retry Original Request
        B-->>F: Response
        F-->>C: Display Data
    end
```

## Task Execution Flow

### Agent Processing Pipeline

```mermaid
flowchart TB
    Start([User Message]) --> Receive[Backend Receives Message]
    
    Receive --> CreateContext[Create Execution Context]
    CreateContext --> InitAgent[Initialize PlanAct Agent]
    
    InitAgent --> SendLLM[Send to LLM]
    SendLLM --> ParseResponse{Response Type?}
    
    ParseResponse -->|Text Only| DirectReply[Send Direct Reply]
    ParseResponse -->|Function Call| SelectTool[Select Tool]
    
    SelectTool --> ToolType{Tool Type?}
    
    ToolType -->|Browser| UseBrowser[Use Browser Tool]
    ToolType -->|Shell| UseShell[Use Shell Tool]
    ToolType -->|File| UseFile[Use File Tool]
    ToolType -->|Search| UseSearch[Use Search Tool]
    ToolType -->|Other| UseOther[Use Other Tools]
    
    UseBrowser --> ExecuteTool[Execute in Sandbox]
    UseShell --> ExecuteTool
    UseFile --> ExecuteTool
    UseSearch --> ExecuteLocal[Execute Locally]
    UseOther --> ExecuteTool
    
    ExecuteTool --> GetResult[Get Tool Result]
    ExecuteLocal --> GetResult
    
    GetResult --> SendSSE[Send SSE Update to Frontend]
    SendSSE --> AppendContext[Append to Context]
    
    AppendContext --> CheckComplete{Task Complete?}
    
    CheckComplete -->|No| SendLLM
    CheckComplete -->|Yes| FinalReply[Generate Final Response]
    
    DirectReply --> SaveHistory[Save to MongoDB]
    FinalReply --> SaveHistory
    
    SaveHistory --> NotifyUser[Notify User via SSE]
    NotifyUser --> End([Complete])
    
    style Start fill:#4caf50
    style SelectTool fill:#ff9800
    style ExecuteTool fill:#9c27b0
    style SaveHistory fill:#2196f3
    style End fill:#f44336
```

### Sandbox Lifecycle

```mermaid
stateDiagram-v2
    [*] --> Requested: User Creates Session
    
    Requested --> Creating: Allocate Resources
    Creating --> Starting: Docker Container Created
    Starting --> Initializing: Container Running
    
    Initializing --> Ready: Services Started<br/>(VNC, API, Chrome)
    
    Ready --> Active: Processing Task
    Active --> Ready: Task Complete
    
    Ready --> Paused: User Inactive
    Paused --> Ready: User Returns
    
    Active --> Error: Tool Failure
    Error --> Ready: Error Handled
    Error --> Terminating: Critical Error
    
    Ready --> Terminating: TTL Expired
    Paused --> Terminating: TTL Expired
    Active --> Terminating: User Ends Session
    
    Terminating --> Cleanup: Stop Services
    Cleanup --> Removed: Container Deleted
    Removed --> [*]
    
    note right of Ready
        Sandbox is ready to
        execute tools and
        handle user requests
    end note
    
    note right of Terminating
        Cleanup process:
        - Close Chrome
        - Stop VNC
        - Save state
        - Remove container
    end note
```

## Deployment Architecture

### Docker Compose Deployment

```mermaid
graph TB
    subgraph "Host Machine"
        subgraph "Docker Network: sheikh-ai-network"
            subgraph "Frontend Container"
                Nginx[Nginx Server<br/>Port: 80]
                VueApp[Vue 3 App<br/>Static Files]
            end
            
            subgraph "Backend Container"
                FastAPI[FastAPI Server<br/>Port: 8000]
                Uvicorn[Uvicorn ASGI]
            end
            
            subgraph "Database Containers"
                MongoDB[MongoDB 7.0<br/>Port: 27017]
                Redis[Redis 7.0<br/>Port: 6379]
            end
            
            subgraph "Dynamic Sandboxes"
                Sand1[Sandbox 1<br/>Ubuntu + Chrome]
                Sand2[Sandbox 2<br/>Ubuntu + Chrome]
                SandN[Sandbox N<br/>Ubuntu + Chrome]
            end
        end
        
        HostPort[Host Port 5173] --> Nginx
        DockerSocket[/var/run/docker.sock] -.-> FastAPI
        
        VueApp --> FastAPI
        FastAPI --> MongoDB
        FastAPI --> Redis
        FastAPI -.Creates/Manages.-> Sand1
        FastAPI -.Creates/Manages.-> Sand2
        FastAPI -.Creates/Manages.-> SandN
        
        Volume1[(mongodb_data)] --> MongoDB
        Volume2[(logs)] --> FastAPI
    end
    
    Internet((Internet)) --> HostPort
    
    style Nginx fill:#009688
    style FastAPI fill:#ff9800
    style MongoDB fill:#47a248
    style Redis fill:#dc382d
    style Sand1 fill:#2496ed
    style Sand2 fill:#2496ed
    style SandN fill:#2496ed
```

### Kubernetes Deployment (Future)

```mermaid
graph TB
    subgraph "Kubernetes Cluster"
        subgraph "Ingress Layer"
            Ingress[Ingress Controller<br/>nginx-ingress]
        end
        
        subgraph "Frontend Namespace"
            FrontSvc[Frontend Service]
            FrontDep[Frontend Deployment<br/>Replicas: 3]
            FrontPod1[Frontend Pod 1]
            FrontPod2[Frontend Pod 2]
            FrontPod3[Frontend Pod 3]
        end
        
        subgraph "Backend Namespace"
            BackSvc[Backend Service]
            BackDep[Backend Deployment<br/>Replicas: 5]
            BackPod1[Backend Pod 1]
            BackPod2[Backend Pod 2]
            BackPod3[Backend Pod 3]
        end
        
        subgraph "Data Namespace"
            MongoSvc[MongoDB Service]
            MongoSS[MongoDB StatefulSet]
            MongoPod1[MongoDB Pod 1]
            MongoPod2[MongoDB Pod 2]
            
            RedisSvc[Redis Service]
            RedisDep[Redis Deployment]
            RedisPod[Redis Pod]
        end
        
        subgraph "Sandbox Namespace"
            SandboxPool[Sandbox Pool<br/>DaemonSet]
            SandPod1[Sandbox Pod 1]
            SandPod2[Sandbox Pod 2]
        end
        
        subgraph "Storage"
            PVC1[PVC: MongoDB Data]
            PVC2[PVC: Logs]
        end
    end
    
    Internet((Internet)) --> Ingress
    Ingress --> FrontSvc
    Ingress --> BackSvc
    
    FrontSvc --> FrontDep
    FrontDep --> FrontPod1
    FrontDep --> FrontPod2
    FrontDep --> FrontPod3
    
    BackSvc --> BackDep
    BackDep --> BackPod1
    BackDep --> BackPod2
    BackDep --> BackPod3
    
    BackPod1 --> MongoSvc
    BackPod1 --> RedisSvc
    BackPod1 --> SandboxPool
    
    MongoSvc --> MongoSS
    MongoSS --> MongoPod1
    MongoSS --> MongoPod2
    
    RedisSvc --> RedisDep
    RedisDep --> RedisPod
    
    SandboxPool --> SandPod1
    SandboxPool --> SandPod2
    
    MongoPod1 --> PVC1
    MongoPod2 --> PVC1
    BackPod1 --> PVC2
    
    style Ingress fill:#326ce5
    style FrontSvc fill:#42b883
    style BackSvc fill:#009688
    style MongoSvc fill:#47a248
    style RedisSvc fill:#dc382d
    style SandboxPool fill:#2496ed
```

## Development Workflow

### Git Workflow

```mermaid
gitGraph
    commit id: "Initial Commit"
    branch develop
    checkout develop
    commit id: "Setup Project Structure"
    
    branch feature/authentication
    checkout feature/authentication
    commit id: "Add JWT Auth"
    commit id: "Add OAuth Support"
    
    checkout develop
    merge feature/authentication
    
    branch feature/sandbox
    checkout feature/sandbox
    commit id: "Docker Sandbox Setup"
    commit id: "Add VNC Support"
    
    checkout develop
    merge feature/sandbox
    
    branch feature/frontend
    checkout feature/frontend
    commit id: "Vue 3 Setup"
    commit id: "Add Chat UI"
    
    checkout develop
    merge feature/frontend
    
    checkout main
    merge develop tag: "v1.0.0"
    
    checkout develop
    branch hotfix/security
    checkout hotfix/security
    commit id: "Fix: Security Patch"
    
    checkout main
    merge hotfix/security tag: "v1.0.1"
    
    checkout develop
    merge hotfix/security
```

### CI/CD Pipeline

```mermaid
flowchart LR
    subgraph "Developer"
        Code[Write Code] --> Commit[Git Commit]
        Commit --> Push[Git Push]
    end
    
    subgraph "GitHub Actions"
        Push --> Trigger[Trigger Workflow]
        
        Trigger --> Lint[Code Linting<br/>ESLint, Black]
        Trigger --> Test[Run Tests<br/>Jest, Pytest]
        Trigger --> Build[Build Images<br/>Docker Build]
        
        Lint --> Quality{Quality OK?}
        Test --> Quality
        Build --> Quality
        
        Quality -->|Fail| Notify[Notify Developer]
        Quality -->|Pass| Push2Reg[Push to GHCR]
        
        Push2Reg --> Tag{Has Tag?}
        
        Tag -->|Yes| Release[Create Release]
        Tag -->|No| Done1[Done]
        
        Release --> Deploy{Deploy?}
        Deploy -->|Staging| DeployStaging[Deploy to Staging]
        Deploy -->|Production| DeployProd[Deploy to Production]
        Deploy -->|No| Done2[Done]
    end
    
    subgraph "Deployment"
        DeployStaging --> TestStaging[Integration Tests]
        TestStaging --> Approve{Approve?}
        Approve -->|Yes| DeployProd
        Approve -->|No| Rollback[Rollback]
        
        DeployProd --> Monitor[Monitor Health]
        Monitor --> Alert{Issues?}
        Alert -->|Yes| Rollback
        Alert -->|No| Success[Deployment Success]
    end
    
    Notify -.-> Code
    Rollback -.-> Code
    
    style Code fill:#4caf50
    style Lint fill:#2196f3
    style Test fill:#2196f3
    style Build fill:#ff9800
    style Release fill:#9c27b0
    style DeployProd fill:#f44336
    style Success fill:#4caf50
```

### Local Development Setup

```mermaid
flowchart TD
    Start([Start Development]) --> Clone[Clone Repository]
    Clone --> CopyEnv[Copy .env.example to .env]
    CopyEnv --> ConfigEnv[Configure Environment]
    
    ConfigEnv --> InstallDep{Install Dependencies}
    
    InstallDep --> Backend[Backend: pip install]
    InstallDep --> Frontend[Frontend: npm install]
    
    Backend --> StartServices[Start Support Services<br/>docker-compose up -d mongodb redis]
    Frontend --> StartServices
    
    StartServices --> RunDev{Run in Dev Mode}
    
    RunDev --> DevScript[./dev.sh up<br/>All-in-One]
    RunDev --> Manual[Manual Start]
    
    Manual --> StartBack[uvicorn app.main:app --reload]
    Manual --> StartFront[npm run dev]
    
    DevScript --> DevReady[Development Ready]
    StartBack --> DevReady
    StartFront --> DevReady
    
    DevReady --> Develop[Write Code]
    Develop --> HotReload[Hot Reload]
    HotReload --> TestLocal[Test Locally]
    
    TestLocal --> OK{Works?}
    OK -->|No| Debug[Debug Issues]
    OK -->|Yes| Commit[Git Commit]
    
    Debug --> Develop
    
    Commit --> PushBranch[Push to Branch]
    PushBranch --> PR[Create Pull Request]
    
    PR --> Review[Code Review]
    Review --> Approved{Approved?}
    
    Approved -->|No| FixIssues[Address Feedback]
    Approved -->|Yes| Merge[Merge to Main]
    
    FixIssues --> Develop
    
    Merge --> End([Complete])
    
    style Start fill:#4caf50
    style DevReady fill:#2196f3
    style Commit fill:#ff9800
    style Merge fill:#9c27b0
    style End fill:#f44336
```

## Data Flow

### Message Processing

```mermaid
flowchart TB
    subgraph "Frontend"
        UI[User Interface] --> MsgInput[Message Input]
        MsgInput --> Validate[Validate Input]
    end
    
    subgraph "API Layer"
        Validate --> API[POST /api/messages]
        API --> AuthCheck{Authenticated?}
        AuthCheck -->|No| Reject[401 Unauthorized]
        AuthCheck -->|Yes| ParseMsg[Parse Message]
    end
    
    subgraph "Business Logic"
        ParseMsg --> LoadContext[Load Session Context<br/>from MongoDB]
        LoadContext --> InitAgent[Initialize Agent]
        
        InitAgent --> LLMRequest[Request to LLM]
        LLMRequest --> LLMResp{Response Type?}
        
        LLMResp -->|Text| FormatText[Format Text Response]
        LLMResp -->|Tool Call| IdentifyTool[Identify Tool]
        
        IdentifyTool --> ExecTool[Execute Tool]
        ExecTool --> ToolResult[Get Tool Result]
        ToolResult --> UpdateContext[Update Context]
        UpdateContext --> LLMRequest
    end
    
    subgraph "Persistence"
        FormatText --> SaveMsg[Save Message to MongoDB]
        UpdateContext --> CacheUpdate[Update Redis Cache]
    end
    
    subgraph "Real-time Updates"
        SaveMsg --> SSEEvent[Create SSE Event]
        CacheUpdate --> SSEEvent
        SSEEvent --> BroadcastSSE[Broadcast to Client]
    end
    
    BroadcastSSE --> UpdateUI[Update UI]
    UpdateUI --> DisplayMsg[Display Message]
    
    style UI fill:#e1f5ff
    style API fill:#009688
    style LLMRequest fill:#10a37f
    style ExecTool fill:#ff9800
    style SaveMsg fill:#47a248
    style BroadcastSSE fill:#2196f3
```

---

## Diagram Legend

### Color Coding

- 🟢 **Green** (#4caf50): Start/Success states
- 🔵 **Blue** (#2196f3): Processing/Active states
- 🟠 **Orange** (#ff9800): Important operations
- 🟣 **Purple** (#9c27b0): Critical operations
- 🔴 **Red** (#f44336): End/Error states
- 🟢 **Teal** (#009688): API/Services
- 🟢 **Green DB** (#47a248): MongoDB
- 🔴 **Red DB** (#dc382d): Redis
- 🔵 **Docker Blue** (#2496ed): Docker/Containers
- 🟢 **LLM Green** (#10a37f): AI/LLM Services

### Component Abbreviations

- **API**: Application Programming Interface
- **SSE**: Server-Sent Events
- **JWT**: JSON Web Token
- **VNC**: Virtual Network Computing
- **LLM**: Large Language Model
- **PVC**: Persistent Volume Claim
- **GHCR**: GitHub Container Registry

---

*This documentation is automatically generated and kept in sync with the codebase.*
