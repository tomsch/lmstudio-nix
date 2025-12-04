# LM Studio for NixOS

Unofficial Nix package for [LM Studio](https://lmstudio.ai) - discover, download, and run local LLMs.

## Installation

### Flake Input (NixOS/Home Manager)

```nix
{
  inputs.lmstudio.url = "github:tomsch/lmstudio-nix";

  outputs = { self, nixpkgs, lmstudio, ... }: {
    # NixOS
    nixosConfigurations.myhost = nixpkgs.lib.nixosSystem {
      modules = [{
        nixpkgs.config.allowUnfree = true;
        environment.systemPackages = [
          lmstudio.packages.x86_64-linux.default
        ];
      }];
    };
  };
}
```

### Direct Run (no install)

```bash
nix run github:tomsch/lmstudio-nix --impure
```

### Imperative Install

```bash
nix profile install github:tomsch/lmstudio-nix --impure
```

## Features

- **Run LLMs locally** - complete privacy, no data leaves your machine
- **Download models** from Hugging Face with one click
- **GPU acceleration** with NVIDIA CUDA and AMD ROCm support
- **OpenAI-compatible API** server for local development
- **Chat interface** with customizable system prompts
- Supports Llama, Mistral, Phi, Gemma, DeepSeek, and more

## System Requirements

- x86_64 Linux
- Recommended: NVIDIA or AMD GPU with 8GB+ VRAM
- Minimum 16GB RAM
- AVX2 compatible processor

## Update Package

Maintainers can update to the latest version:

```bash
./update.sh
```

## License

The Nix packaging is MIT. LM Studio itself is proprietary software.

## Links

- [LM Studio](https://lmstudio.ai)
- [LM Studio Blog](https://lmstudio.ai/blog)
- [LM Studio Docs](https://lmstudio.ai/docs)
