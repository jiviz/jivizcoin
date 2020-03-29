# This Makefile is meant to be used by people that do not usually work
# with Go source code. If you know what GOPATH is then you probably
# don't need to bother with make.

.PHONY: jiviz android ios jiviz-cross swarm evm all test clean
.PHONY: jiviz-linux jiviz-linux-386 jiviz-linux-amd64 jiviz-linux-mips64 jiviz-linux-mips64le
.PHONY: jiviz-linux-arm jiviz-linux-arm-5 jiviz-linux-arm-6 jiviz-linux-arm-7 jiviz-linux-arm64
.PHONY: jiviz-darwin jiviz-darwin-386 jiviz-darwin-amd64
.PHONY: jiviz-windows jiviz-windows-386 jiviz-windows-amd64

GOBIN = $(shell pwd)/build/bin
GO ?= latest

jiviz:
	build/env.sh go run build/ci.go install ./cmd/jiviz
	@echo "Done building."
	@echo "Run \"$(GOBIN)/jiviz\" to launch jiviz."

swarm:
	build/env.sh go run build/ci.go install ./cmd/swarm
	@echo "Done building."
	@echo "Run \"$(GOBIN)/swarm\" to launch swarm."

all:
	build/env.sh go run build/ci.go install

android:
	build/env.sh go run build/ci.go aar --local
	@echo "Done building."
	@echo "Import \"$(GOBIN)/jiviz.aar\" to use the library."

ios:
	build/env.sh go run build/ci.go xcode --local
	@echo "Done building."
	@echo "Import \"$(GOBIN)/jiviz.framework\" to use the library."

test: all
	build/env.sh go run build/ci.go test

clean:
	rm -fr build/_workspace/pkg/ $(GOBIN)/*

# The devtools target installs tools required for 'go generate'.
# You need to put $GOBIN (or $GOPATH/bin) in your PATH to use 'go generate'.

devtools:
	env GOBIN= go get -u golang.org/x/tools/cmd/stringer
	env GOBIN= go get -u github.com/jteeuwen/go-bindata/go-bindata
	env GOBIN= go get -u github.com/fjl/gencodec
	env GOBIN= go install ./cmd/abigen

# Cross Compilation Targets (xgo)

jiviz-cross: jiviz-linux jiviz-darwin jiviz-windows jiviz-android jiviz-ios
	@echo "Full cross compilation done:"
	@ls -ld $(GOBIN)/jiviz-*

jiviz-linux: jiviz-linux-386 jiviz-linux-amd64 jiviz-linux-arm jiviz-linux-mips64 jiviz-linux-mips64le
	@echo "Linux cross compilation done:"
	@ls -ld $(GOBIN)/jiviz-linux-*

jiviz-linux-386:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/386 -v ./cmd/jiviz
	@echo "Linux 386 cross compilation done:"
	@ls -ld $(GOBIN)/jiviz-linux-* | grep 386

jiviz-linux-amd64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/amd64 -v ./cmd/jiviz
	@echo "Linux amd64 cross compilation done:"
	@ls -ld $(GOBIN)/jiviz-linux-* | grep amd64

jiviz-linux-arm: jiviz-linux-arm-5 jiviz-linux-arm-6 jiviz-linux-arm-7 jiviz-linux-arm64
	@echo "Linux ARM cross compilation done:"
	@ls -ld $(GOBIN)/jiviz-linux-* | grep arm

jiviz-linux-arm-5:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm-5 -v ./cmd/jiviz
	@echo "Linux ARMv5 cross compilation done:"
	@ls -ld $(GOBIN)/jiviz-linux-* | grep arm-5

jiviz-linux-arm-6:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm-6 -v ./cmd/jiviz
	@echo "Linux ARMv6 cross compilation done:"
	@ls -ld $(GOBIN)/jiviz-linux-* | grep arm-6

jiviz-linux-arm-7:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm-7 -v ./cmd/jiviz
	@echo "Linux ARMv7 cross compilation done:"
	@ls -ld $(GOBIN)/jiviz-linux-* | grep arm-7

jiviz-linux-arm64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/arm64 -v ./cmd/jiviz
	@echo "Linux ARM64 cross compilation done:"
	@ls -ld $(GOBIN)/jiviz-linux-* | grep arm64

jiviz-linux-mips:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mips --ldflags '-extldflags "-static"' -v ./cmd/jiviz
	@echo "Linux MIPS cross compilation done:"
	@ls -ld $(GOBIN)/jiviz-linux-* | grep mips

jiviz-linux-mipsle:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mipsle --ldflags '-extldflags "-static"' -v ./cmd/jiviz
	@echo "Linux MIPSle cross compilation done:"
	@ls -ld $(GOBIN)/jiviz-linux-* | grep mipsle

jiviz-linux-mips64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mips64 --ldflags '-extldflags "-static"' -v ./cmd/jiviz
	@echo "Linux MIPS64 cross compilation done:"
	@ls -ld $(GOBIN)/jiviz-linux-* | grep mips64

jiviz-linux-mips64le:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=linux/mips64le --ldflags '-extldflags "-static"' -v ./cmd/jiviz
	@echo "Linux MIPS64le cross compilation done:"
	@ls -ld $(GOBIN)/jiviz-linux-* | grep mips64le

jiviz-darwin: jiviz-darwin-386 jiviz-darwin-amd64
	@echo "Darwin cross compilation done:"
	@ls -ld $(GOBIN)/jiviz-darwin-*

jiviz-darwin-386:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=darwin/386 -v ./cmd/jiviz
	@echo "Darwin 386 cross compilation done:"
	@ls -ld $(GOBIN)/jiviz-darwin-* | grep 386

jiviz-darwin-amd64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=darwin/amd64 -v ./cmd/jiviz
	@echo "Darwin amd64 cross compilation done:"
	@ls -ld $(GOBIN)/jiviz-darwin-* | grep amd64

jiviz-windows: jiviz-windows-386 jiviz-windows-amd64
	@echo "Windows cross compilation done:"
	@ls -ld $(GOBIN)/jiviz-windows-*

jiviz-windows-386:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=windows/386 -v ./cmd/jiviz
	@echo "Windows 386 cross compilation done:"
	@ls -ld $(GOBIN)/jiviz-windows-* | grep 386

jiviz-windows-amd64:
	build/env.sh go run build/ci.go xgo -- --go=$(GO) --targets=windows/amd64 -v ./cmd/jiviz
	@echo "Windows amd64 cross compilation done:"
	@ls -ld $(GOBIN)/jiviz-windows-* | grep amd64
