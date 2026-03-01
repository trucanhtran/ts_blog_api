# API Structure Guide

Cấu trúc API chuẩn cho ứng dụng Rails. Bạn có thể sao chép mô hình này cho các resource khác.

## Folder Structure

```
app/
├── controllers/
│   └── api/
│       ├── base_controller.rb       # Base class for all API controllers
│       └── v1/
│           └── posts_controller.rb  # Example: Posts API
├── serializers/
│   └── post_serializer.rb           # Response formatter for Post
└── services/
    └── posts/
        └── create_service.rb        # Business logic service
```

## Các file trong cấu trúc

### 1. BaseController (`app/controllers/api/base_controller.rb`)

- Chứa logic chung cho tất cả API controllers
- Error handling
- JSON response formatting
- Pagination helper
- Token authentication (ready to use)

### 2. Resource Controllers (`app/controllers/api/v1/posts_controller.rb`)

Ví dụ cho Posts resource:

- `index` - List all (with pagination)
- `show` - Get one
- `create` - Create new
- `update` - Update existing
- `destroy` - Delete

**Sao chép mô hình này cho resource khác:**

```ruby
# app/controllers/api/v1/comments_controller.rb
module Api
  module V1
    class CommentsController < ::Api::BaseController
      # Tương tự như PostsController
    end
  end
end
```

### 3. Serializers (`app/serializers/post_serializer.rb`)

- Format dữ liệu response
- Thêm computed attributes (summary, word_count, etc.)
- Ngăn expose sensitive fields

**Tạo serializer khác:**

```ruby
class CommentSerializer < ActiveModel::Serializer
  attributes :id, :content, :created_at
  belongs_to :post
  belongs_to :user
end
```

### 4. Services (`app/services/posts/create_service.rb`)

- Organize complex business logic
- Reusable từ controllers, jobs, etc.

**Usage:**

```ruby
result = Posts::CreateService.call(title: "...", content: "...", published: true)
# => { success: true, data: post } or { success: false, errors: [...] }
```

## Setup Routes

Thêm vào `config/routes.rb`:

```ruby
namespace :api do
  namespace :v1 do
    resources :posts
    resources :comments
    resources :users
  end
end
```

## API Endpoints Example

Xem chi tiết trong [API_SETUP_EXAMPLE.md](../API_SETUP_EXAMPLE.md)

### Quick Examples:

**List posts (with pagination):**

```bash
curl http://localhost:3000/api/v1/posts?page=1&per_page=20
```

**Get single post:**

```bash
curl http://localhost:3000/api/v1/posts/1
```

**Create post:**

```bash
curl -X POST http://localhost:3000/api/v1/posts \
  -H "Content-Type: application/json" \
  -d '{"post": {"title": "...", "content": "...", "published": true}}'
```

**Update post:**

```bash
curl -X PATCH http://localhost:3000/api/v1/posts/1 \
  -H "Content-Type: application/json" \
  -d '{"post": {"title": "Updated"}}'
```

**Delete post:**

```bash
curl -X DELETE http://localhost:3000/api/v1/posts/1
```

## Response Format

Tất cả responses theo format:

**Success (200/201):**

```json
{
  "id": 1,
  "title": "...",
  "content": "...",
  "summary": "...",
  "word_count": 42,
  "created_at": "2026-03-01T...",
  "updated_at": "2026-03-01T..."
}
```

**List (with pagination):**

```json
{
  "data": [...],
  "meta": {
    "page": 1,
    "per_page": 20,
    "total": 100
  }
}
```

**Error (4xx/5xx):**

```json
{
  "error": "Resource not found"
}
```

hoặc:

```json
{
  "errors": ["Title can't be blank", "Content is too short"]
}
```

## Điều gì cần làm khi thêm resource mới

1. **Tạo Model** (nếu chưa có)

   ```bash
   docker compose run --rm web bin/rails g model Comment post:references content:text
   docker compose run --rm web bin/rails db:migrate
   ```

2. **Tạo Serializer** (`app/serializers/comment_serializer.rb`)

3. **Tạo Controller** (`app/controllers/api/v1/comments_controller.rb`)
   - Copy từ PostsController, thay đổi model name

4. **Tạo Service** (nếu có business logic)

5. **Thêm routes** trong `config/routes.rb`

   ```ruby
   resources :comments
   ```

6. **Run linter & commit:**
   ```bash
   docker compose run --rm web bundle exec rubocop -A
   git add .
   git commit -m "feat: add comments API"
   ```

---

**Notes:**

- Luôn inherit từ `Api::BaseController`
- Serialize responses với Serializer
- Move complex logic vào Services
- Công thức lặp lại (repetition) là OK - dễ customize cho từng resource
