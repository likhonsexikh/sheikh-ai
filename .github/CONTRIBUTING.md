# Contributing to Sheikh AI

First off, thank you for considering contributing to Sheikh AI! It's people like you that make Sheikh AI such a great tool.

## Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [How Can I Contribute?](#how-can-i-contribute)
- [Development Setup](#development-setup)
- [Pull Request Process](#pull-request-process)
- [Style Guidelines](#style-guidelines)
- [Community](#community)

## Code of Conduct

This project and everyone participating in it is governed by our [Code of Conduct](CODE_OF_CONDUCT.md). By participating, you are expected to uphold this code.

## Getting Started

Before you begin:
- Check if an issue already exists for what you want to work on
- For major changes, please open an issue first to discuss what you would like to change
- Make sure you have read our documentation

## How Can I Contribute?

### Reporting Bugs

Before creating bug reports, please check existing issues to avoid duplicates. When you create a bug report, include as many details as possible:

- **Use a clear and descriptive title**
- **Describe the exact steps to reproduce the problem**
- **Provide specific examples**
- **Describe the behavior you observed and what you expected**
- **Include screenshots if applicable**
- **Include your environment details** (OS, browser, versions, etc.)

**Bug Report Template:**
```markdown
**Description:**
A clear description of the bug.

**Steps to Reproduce:**
1. Go to '...'
2. Click on '...'
3. See error

**Expected Behavior:**
What you expected to happen.

**Actual Behavior:**
What actually happened.

**Environment:**
- OS: [e.g., Ubuntu 22.04]
- Browser: [e.g., Chrome 120]
- Sheikh AI Version: [e.g., v1.0.0]

**Screenshots:**
If applicable, add screenshots.

**Additional Context:**
Any other relevant information.
```

### Suggesting Enhancements

Enhancement suggestions are tracked as GitHub issues. Create an issue and provide:

- **Use a clear and descriptive title**
- **Provide a detailed description of the enhancement**
- **Explain why this enhancement would be useful**
- **List examples of how it would work**

### Your First Code Contribution

Unsure where to begin? Look for issues labeled:
- `good first issue` - Good for newcomers
- `help wanted` - Extra attention needed
- `documentation` - Improvements to documentation

### Pull Requests

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Make your changes
4. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
5. Push to the branch (`git push origin feature/AmazingFeature`)
6. Open a Pull Request

## Development Setup

### Prerequisites

- Python 3.11+
- Node.js 18+
- Docker and Docker Compose
- Git

### Local Development Setup

1. **Clone the repository:**
```bash
git clone https://github.com/likhonsexikh/sheikh-ai.git
cd sheikh-ai
```

2. **Backend Setup:**
```bash
cd backend
python -m venv venv
source venv/bin/activate  # On Windows: venv\Scripts\activate
pip install -r requirements.txt
```

3. **Frontend Setup:**
```bash
cd frontend
npm install
```

4. **Environment Configuration:**
```bash
cp .env.example .env
# Edit .env with your configuration
```

5. **Start Development Services:**
```bash
docker-compose up -d mongodb redis
```

6. **Run Backend:**
```bash
cd backend
uvicorn app.main:app --reload
```

7. **Run Frontend:**
```bash
cd frontend
npm run dev
```

### Running Tests

**Backend Tests:**
```bash
cd backend
pytest
```

**Frontend Tests:**
```bash
cd frontend
npm run test
```

**E2E Tests:**
```bash
npm run test:e2e
```

## Pull Request Process

1. **Update Documentation:** Update README.md and other docs with details of changes
2. **Add Tests:** Ensure your code has appropriate test coverage
3. **Follow Style Guidelines:** Make sure your code follows our style guidelines
4. **Update CHANGELOG:** Add your changes to CHANGELOG.md under [Unreleased]
5. **Link Issues:** Reference any related issues in your PR description
6. **Request Review:** Request review from maintainers
7. **Address Feedback:** Make requested changes promptly

### PR Checklist

- [ ] My code follows the project's style guidelines
- [ ] I have performed a self-review of my code
- [ ] I have commented my code, particularly in hard-to-understand areas
- [ ] I have made corresponding changes to the documentation
- [ ] My changes generate no new warnings
- [ ] I have added tests that prove my fix is effective or that my feature works
- [ ] New and existing unit tests pass locally with my changes
- [ ] Any dependent changes have been merged and published

## Style Guidelines

### Python Code Style

- Follow [PEP 8](https://pep8.org/) style guide
- Use [Black](https://github.com/psf/black) for code formatting
- Use type hints for function signatures
- Maximum line length: 100 characters
- Write docstrings for all public methods

**Example:**
```python
from typing import Optional

def process_user_input(user_id: str, message: str) -> Optional[dict]:
    """
    Process user input and return response.
    
    Args:
        user_id: Unique identifier for the user
        message: User's input message
        
    Returns:
        Dictionary containing response data, or None if processing failed
    """
    # Implementation
    pass
```

### TypeScript/JavaScript Code Style

- Follow [Airbnb JavaScript Style Guide](https://github.com/airbnb/javascript)
- Use [Prettier](https://prettier.io/) for code formatting
- Use TypeScript for type safety
- Use Vue 3 Composition API

**Example:**
```typescript
interface UserMessage {
  userId: string;
  message: string;
  timestamp: Date;
}

const processMessage = (data: UserMessage): Promise<Response> => {
  // Implementation
};
```

### Commit Message Guidelines

Follow [Conventional Commits](https://www.conventionalcommits.org/):

```
<type>(<scope>): <subject>

<body>

<footer>
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, etc.)
- `refactor`: Code refactoring
- `test`: Adding or updating tests
- `chore`: Maintenance tasks

**Examples:**
```
feat(backend): add user authentication endpoint

fix(frontend): resolve chat message rendering issue

docs(readme): update installation instructions

refactor(sandbox): improve code execution safety
```

### Documentation Style

- Use clear, concise language
- Include code examples where applicable
- Keep documentation up-to-date with code changes
- Use proper Markdown formatting

## Project Structure

```
sheikh-ai/
├── backend/           # FastAPI backend
│   ├── app/
│   │   ├── api/      # API endpoints
│   │   ├── core/     # Core functionality
│   │   ├── models/   # Data models
│   │   └── services/ # Business logic
│   └── tests/        # Backend tests
├── frontend/         # Vue 3 frontend
│   ├── src/
│   │   ├── components/
│   │   ├── views/
│   │   └── stores/
│   └── tests/       # Frontend tests
├── sandbox/         # Code execution sandbox
└── docs/           # Documentation
```

## Community

### Getting Help

- **Documentation:** Check our [docs](https://docs.sheikhAI.com)
- **GitHub Discussions:** Ask questions and share ideas
- **Issues:** Report bugs and request features
- **Email:** Contact maintainers at likhonsexikh@gmail.com

### Stay Updated

- **Watch** the repository for updates
- **Star** the repository if you find it useful
- **Follow** [@likhonsexikh](https://github.com/likhonsexikh) on GitHub

## Recognition

Contributors will be recognized in:
- README.md contributors section
- Release notes
- Project documentation

## License

By contributing to Sheikh AI, you agree that your contributions will be licensed under the MIT License.

## Questions?

Don't hesitate to ask questions! Open an issue or reach out to the maintainers.

---

**Thank you for contributing to Sheikh AI! Your efforts help make this project better for everyone.** 🎉
