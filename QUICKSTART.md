# OpenAPI Generator - Quick Start Guide

## ✅ Setup hoàn tất!

OpenAPI Generator đã được cài đặt và sẵn sàng sử dụng.

## 🚀 Sử dụng nhanh

### 1. Validate Swagger file
```bash
make openapi-validate
```

### 2. Generate TypeScript Client
```bash
make openapi-generate-typescript
```

Client sẽ được tạo tại: `clients/typescript/`

### 3. Generate tất cả clients (TypeScript, JavaScript, Ruby, Python)
```bash
make openapi-generate-all
```

## 📁 Cấu trúc đã tạo

```
ts_blog_api/
├── swagger/v1/swagger.yaml          ✅ OpenAPI spec (đã validate)
├── clients/                         ✅ Generated clients
│   └── typescript/                  ✅ TypeScript client (đã generate)
│       ├── api.ts                   - API classes
│       ├── models/                  - TypeScript models
│       ├── docs/                    - Documentation
│       └── package.json             - NPM package
├── Makefile                         ✅ Docker commands
├── package.json                     ✅ NPM scripts (cần Java 11+)
├── openapitools.json               ✅ Generator config
└── OPENAPI_SETUP.md                ✅ Full documentation
```

## 💡 Sử dụng TypeScript Client

### Install
```bash
cd clients/typescript
npm install
npm run build
```

### Sử dụng trong project
```typescript
import { Configuration, DefaultApi, AuthenticationApi } from './clients/typescript';

// Configure API
const config = new Configuration({
  basePath: 'http://localhost:3000',
});

const authApi = new AuthenticationApi(config);
const api = new DefaultApi(config);

// Login
const loginResponse = await authApi.apiV1LoginPost({
  user: {
    email: 'user@example.com',
    password: 'password123'
  }
});

// Get posts
const posts = await api.apiV1PostsGet({
  page: 1,
  perPage: 20
});

// Create post
const newPost = await api.apiV1PostsPost({
  post: {
    title: 'My Post',
    content: 'Content here',
    authorId: 1,
    published: false
  }
});
```

## 🔧 Commands

### Docker (Recommended - không cần Java)
```bash
make help                           # Xem tất cả commands
make openapi-validate              # Validate spec
make openapi-generate-typescript   # Generate TypeScript
make openapi-generate-javascript   # Generate JavaScript
make openapi-generate-ruby         # Generate Ruby
make openapi-generate-python       # Generate Python
make openapi-generate-all          # Generate tất cả
```

### NPM (Cần Java 11+)
```bash
npm run openapi:validate
npm run openapi:generate:typescript
npm run openapi:generate:javascript
npm run openapi:generate:ruby
npm run openapi:generate:python
npm run openapi:generate:all
```

## ⚠️ Lưu ý quan trọng

### 1. Warnings về operationId
Bạn sẽ thấy warnings:
```
Empty operationId found for path: post /api/v1/signup
```

**Giải pháp**: Thêm `operationId` vào swagger.yaml để có tên function đẹp hơn:

```yaml
/api/v1/signup:
  post:
    operationId: signup    # Thêm dòng này
    summary: User signup
```

### 2. Server URL
Warnings:
```
'servers' not defined in spec. Default to [http://localhost]
```

**Giải pháp**: Thêm servers vào swagger.yaml:

```yaml
openapi: 3.0.1
info:
  title: Blog API
  version: v1

servers:
  - url: http://localhost:3000
    description: Development server
  - url: https://api.example.com
    description: Production server
```

## 📚 Tài liệu đầy đủ

Xem file `OPENAPI_SETUP.md` để biết thêm chi tiết về:
- Cài đặt chi tiết
- Customization
- Tất cả generators có sẵn (50+ languages)
- CI/CD integration
- Troubleshooting

## 🎯 Next Steps

1. **Cải thiện Swagger spec**:
   - Thêm `operationId` cho mỗi endpoint
   - Thêm `servers` configuration
   - Thêm examples cho request/response

2. **Publish clients**:
   - TypeScript: Publish to NPM
   - Ruby: Publish to RubyGems
   - Python: Publish to PyPI

3. **Tích hợp vào CI/CD**:
   - Auto-generate khi swagger.yaml thay đổi
   - Auto-publish clients

## 🔗 Resources

- [OpenAPI Generator Docs](https://openapi-generator.tech/)
- [TypeScript Axios Generator](https://openapi-generator.tech/docs/generators/typescript-axios)
- [All Generators](https://openapi-generator.tech/docs/generators)
