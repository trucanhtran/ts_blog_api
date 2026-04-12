.PHONY: help openapi-validate openapi-generate-typescript openapi-generate-javascript openapi-generate-ruby openapi-generate-python openapi-generate-all

help:
	@echo "OpenAPI Generator Commands (using Docker)"
	@echo ""
	@echo "  make openapi-validate              - Validate swagger.yaml"
	@echo "  make openapi-generate-typescript   - Generate TypeScript client"
	@echo "  make openapi-generate-javascript   - Generate JavaScript client"
	@echo "  make openapi-generate-ruby         - Generate Ruby client"
	@echo "  make openapi-generate-python       - Generate Python client"
	@echo "  make openapi-generate-all          - Generate all clients"
	@echo ""

openapi-validate:
	@echo "Validating swagger.yaml..."
	docker run --rm -v ${PWD}:/local openapitools/openapi-generator-cli validate -i /local/swagger/v1/swagger.yaml

openapi-generate-typescript:
	@echo "Generating TypeScript client..."
	docker run --rm -v ${PWD}:/local openapitools/openapi-generator-cli generate \
		-i /local/swagger/v1/swagger.yaml \
		-g typescript-axios \
		-o /local/clients/typescript \
		--additional-properties=supportsES6=true,npmName=@ts-blog/api-client,npmVersion=1.0.0,withInterfaces=true,useSingleRequestParameter=true

openapi-generate-javascript:
	@echo "Generating JavaScript client..."
	docker run --rm -v ${PWD}:/local openapitools/openapi-generator-cli generate \
		-i /local/swagger/v1/swagger.yaml \
		-g javascript \
		-o /local/clients/javascript \
		--additional-properties=projectName=ts-blog-api-client,projectVersion=1.0.0,usePromises=true

openapi-generate-ruby:
	@echo "Generating Ruby client..."
	docker run --rm -v ${PWD}:/local openapitools/openapi-generator-cli generate \
		-i /local/swagger/v1/swagger.yaml \
		-g ruby \
		-o /local/clients/ruby \
		--additional-properties=gemName=ts_blog_api_client,gemVersion=1.0.0,moduleName=TsBlogApiClient

openapi-generate-python:
	@echo "Generating Python client..."
	docker run --rm -v ${PWD}:/local openapitools/openapi-generator-cli generate \
		-i /local/swagger/v1/swagger.yaml \
		-g python \
		-o /local/clients/python \
		--additional-properties=packageName=ts_blog_api_client,packageVersion=1.0.0

openapi-generate-all: openapi-generate-typescript openapi-generate-javascript openapi-generate-ruby openapi-generate-python
	@echo "All clients generated successfully!"
