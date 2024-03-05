# Define proto directories
PROTO_DIRS := v1
PROTO_DST_DIR := api
# Find all .proto files in the proto directories
PROTO_FILES := $(foreach dir,$(PROTO_DIRS),$(wildcard $(dir)/*.proto))

# Default target
all: create_output_dir clean protoc

# Target for generating protoc files
protoc: $(PROTO_FILES)
	@for file in $^ ; do \
		protoc -I. --grpc-gateway_out=./api --grpc-gateway_opt paths=source_relative \
		 --grpc-gateway_opt generate_unbound_methods=true \
		--go_out=./api --go_opt=paths=source_relative \
		--go-grpc_out=./api --go-grpc_opt=paths=source_relative $$file ; \
	done

# Clean target to remove generated files
clean:
	rm -rf ./api/*.go

create_output_dir:
	mkdir -p $(PROTO_DST_DIR)

# Rule to generate Go files from proto files
$(PROTO_DST_DIR)/%.pb.go: $(PROTO_SRC_DIRS)/%.proto
	$(PROTOC) -I. $(GO_OUT_OPT) $(GO_GRPC_OUT_OPT) $(PROTO_SRC_DIRS)/$*.proto
