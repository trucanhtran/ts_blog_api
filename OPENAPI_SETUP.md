# OpenAPI Generator Setup

## Giới thiệu
Project này đã được setup với OpenAPI Generator để tự động generate API clients cho nhiều ngôn ngữ khác nhau từ file Swagger spec.

## Cài đặt

### Option 1: NPM (Recommended)
```bash
# Cài đặt dependencies
npm install

# Kiểm tra version
npm run openapi:version
```

### Option 2: Docker (không cần cài NPM)
```bash
# Pull Docker image
docker pull openapitools/openapi-generator-cli

# Kiểm tra version
docker run --rm openapitools/openapi-generator-cli version
```

## Sử dụng

### Validate Swagger file
```bash
# NPM
npm run openapi:validate

# Docker
docker run --rm -v ${PWD}:/local openapitools/openapi-generator-cli validate -i /local/swagger/v1/swagger.yaml
```

### Generate Client Libraries

#### TypeScript (Axios)
```bash
# NPM
npm run openapi:generate:typescript

# Docker
docker run --rm -v ${PWD}:/local openapitools/openapi-generator-cli generate \
  -i /local/swagger/v1/swagger.yaml \
  -g typescript-axios \
  -o /local/clients/typescript \
  --additional-properties=supportsES6=true,npmName=@ts-blog/api-client,npmVersion=1.0.0
```

Output: `clients/typescript/`

#### JavaScript
```bash
# NPM
npm run openapi:generate:javascript

# Docker
docker run --rm -v ${PWD}:/local openapitools/openapi-generator-cli generate \
  -i /local/swagger/v1/swagger.yaml \
  -g javascript \
  -o /local/clients/javascript \
  --additional-properties=projectName=ts-blog-api-client
```

Output: `clients/javascript/`

#### Ruby
```bash
# NPM
npm run openapi:generate:ruby

# Docker
docker run --rm -v ${PWD}:/local openapitools/openapi-generator-cli generate \
  -i /local/swagger/v1/swagger.yaml \
  -g ruby \
  -o /local/clients/ruby \
  --additional-properties=gemName=ts_blog_api_client,gemVersion=1.0.0
```

Output: `clients/ruby/`

#### Python
```bash
# NPM
npm run openapi:generate:python

# Docker
docker run --rm -v ${PWD}:/local openapitools/openapi-generator-cli generate \
  -i /local/swagger/v1/swagger.yaml \
  -g python \
  -o /local/clients/python \
  --additional-properties=packageName=ts_blog_api_client,packageVersion=1.0.0
```

Output: `clients/python/`

#### Generate tất cả clients
```bash
npm run openapi:generate:all
```

## Các ngôn ngữ được hỗ trợ

OpenAPI Generator hỗ trợ hơn 50+ ngôn ngữ/frameworks:

### Client Libraries
- `typescript-axios` - TypeScript with Axios
- `typescript-fetch` - TypeScript with Fetch API
- `javascript` - JavaScript (ES5/ES6)
- `ruby` - Ruby
- `python` - Python
- `java` - Java
- `kotlin` - Kotlin
- `swift5` - Swift 5
- `go` - Go
- `php` - PHP
- `csharp` - C#
- `dart` - Dart
- `rust` - Rust

### Server Stubs
- `nodejs-express-server` - Node.js Express
- `spring` - Spring Boot
- `rails5` - Ruby on Rails
- `python-flask` - Python Flask
- `go-gin-server` - Go Gin

Xem full list: https://openapi-generator.tech/docs/generators

## Cấu trúc thư mục

```
ts_blog_api/
├── swagger/
│   └── v1/
│       └── swagger.yaml          # OpenAPI spec file
├── clients/                      # Generated clients (gitignored)
│   ├── typescript/
│   ├── javascript/
│   ├── ruby/
│   └── python/
├── package.json                  # NPM scripts
├── openapitools.json            # OpenAPI Generator config
└── .openapi-generator-ignore    # Files to ignore during generation
```

## Customization

### Thay đổi config
Edit file `openapitools.json` để thay đổi settings cho từng generator.

### Thêm generator mới
```bash
# List tất cả generators có sẵn
npx @openapitools/openapi-generator-cli list

# Generate với custom generator
npx @openapitools/openapi-generator-cli generate \
  -i swagger/v1/swagger.yaml \
  -g <generator-name> \
  -o clients/<output-folder>
```

### Additional Properties
Mỗi generator có các options riêng. Xem docs:
https://openapi-generator.tech/docs/generators/

Example cho TypeScript:
```bash
--additional-properties=\
supportsES6=true,\
npmName=@ts-blog/api-client,\
npmVersion=1.0.0,\
withInterfaces=true,\
useSingleRequestParameter=true
```

## Sử dụng Generated Client

### TypeScript Example
```typescript
import { Configuration, PostsApi } from '@ts-blog/api-client';

const config = new Configuration({
  basePath: 'http://localhost:3000',
  headers: {
    'Content-Type': 'application/json',
  }
});

const postsApi = new PostsApi(config);

// Get all posts
const posts = await postsApi.listPosts({ page: 1, perPage: 20 });

// Create a post
const newPost = await postsApi.createPost({
  post: {
    title: 'My Post',
    content: 'Content here',
    authorId: 1
  }
});
```

### JavaScript Example
```javascript
const TsBlogApiClient = require('ts-blog-api-client');

const api = new TsBlogApiClient.PostsApi();
api.apiClient.basePath = 'http://localhost:3000';

// Get all posts
api.listPosts({ page: 1, perPage: 20 })
  .then(data => console.log(data))
  .catch(error => console.error(error));
```

### Ruby Example
```ruby
require 'ts_blog_api_client'

TsBlogApiClient.configure do |config|
  config.host = 'localhost:3000'
  config.scheme = 'http'
end

api = TsBlogApiClient::PostsApi.new

# Get all posts
posts = api.list_posts({ page: 1, per_page: 20 })
```

### Python Example
```python
import ts_blog_api_client
from ts_blog_api_client.api import posts_api

configuration = ts_blog_api_client.Configuration(
    host = "http://localhost:3000"
)

with ts_blog_api_client.ApiClient(configuration) as api_client:
    api_instance = posts_api.PostsApi(api_client)
    posts = api_instance.list_posts(page=1, per_page=20)
```

## CI/CD Integration

### GitHub Actions
```yaml
name: Generate API Clients

on:
  push:
    paths:
      - 'swagger/v1/swagger.yaml'

jobs:
  generate:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: actions/setup-node@v3
        with:
          node-version: '18'
      - run: npm install
      - run: npm run openapi:validate
      - run: npm run openapi:generate:all
      - uses: actions/upload-artifact@v3
        with:
          name: api-clients
          path: clients/
```

## Troubleshooting

### Lỗi schema warning
Warning về schema trong `openapitools.json` là bình thường khi chưa chạy `npm install`. Chạy:
```bash
npm install
```

### Regenerate clients
Nếu muốn regenerate lại từ đầu:
```bash
rm -rf clients/
npm run openapi:generate:all
```

### Validate spec trước khi generate
```bash
npm run openapi:validate
```

## Resources

- [OpenAPI Generator Docs](https://openapi-generator.tech/)
- [GitHub Repository](https://github.com/OpenAPITools/openapi-generator)
- [Generators List](https://openapi-generator.tech/docs/generators)
- [Configuration Options](https://openapi-generator.tech/docs/configuration)
