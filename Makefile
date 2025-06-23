# Binary name
BINARY=blind

# Version information
VERSION=1.0.0
BUILD_TIME=$(shell date +%FT%T%z)

# Build flags
LDFLAGS=-ldflags "-X main.Version=${VERSION} -X main.BuildTime=${BUILD_TIME}"

# Platforms
PLATFORMS=linux/amd64 linux/386 linux/arm64 windows/amd64 windows/386 darwin/amd64 darwin/arm64

# Output directories
DIST_DIR=bin

.PHONY: all clean

all: clean build

build:
	@mkdir -p ${DIST_DIR}
	@for platform in ${PLATFORMS}; do \
		OS=$$(echo $$platform | cut -f1 -d'/'); \
		ARCH=$$(echo $$platform | cut -f2 -d'/'); \
		echo "Building for $$OS/$$ARCH..."; \
		if [ "$$OS" = "windows" ]; then \
			GOOS=$$OS GOARCH=$$ARCH go build ${LDFLAGS} -o ${DIST_DIR}/${BINARY}_$${OS}_$${ARCH}.exe ./main.go; \
		else \
			GOOS=$$OS GOARCH=$$ARCH go build ${LDFLAGS} -o ${DIST_DIR}/${BINARY}_$${OS}_$${ARCH} ./main.go; \
		fi; \
	done

clean:
	@rm -rf ${DIST_DIR}

# Show help
help:
	@echo "Available targets:"
	@echo "  all      - Clean and build all binaries (default)"
	@echo "  build    - Build binaries for all platforms"
	@echo "  clean    - Remove build artifacts"
	@echo "  help     - Show this help message" 
