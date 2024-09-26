# 🌟 Contributing to Cashubrew

First off, thank you for considering contributing to Cashubrew! It's people like you that make Cashubrew such a great tool. 🎉

## 🚀 Getting Started

Before you begin:

- Make sure you have a [GitHub account](https://github.com)
- Familiarize yourself with [Git](https://git-scm.com/)
- Read our [Code of Conduct](CODE_OF_CONDUCT.md)

## 🍴 Forking the Repository

1. Head over to the [Cashubrew repository](https://github.com/keep-starknet-strange/cashubrew) on GitHub
2. Click the "Fork" button in the upper right corner
3. Voilà! You now have your own copy of the repository

## 🛠 Setting Up Your Development Environment

1. Clone your fork locally:

```bash
git clone https://github.com/your-username/cashubrew.git
cd cashubrew
```

1. Add the original repository as a remote called "upstream":

```bash
git remote add upstream https://github.com/keep-starknet-strange/cashubrew.git
```

1. Install dependencies:

```bash
mix deps.get
```

1. Create a new branch for your feature or bugfix:

```bash
git checkout -b your-feature-name
```

## 💡 Making Changes

1. Make your changes in your feature branch
2. Write or adapt tests as needed
3. Run the test suite to ensure everything is working:

```bash
mix test
```

1. Make sure your code follows our style guide:

```bash
mix format
mix credo --strict
```

1. Check for potential security issues:

```bash
mix sobelow
```

1. Run static analysis:

```bash
mix dialyzer
```

## 📤 Submitting Changes

1. Push your changes to your fork on GitHub:

```bash
git push origin your-feature-name
```

1. Go to your fork on GitHub and click the "New Pull Request" button
1. Ensure the base fork is `AbdelStark/cashubrew` and the base is `main`
1. Give your pull request a clear title and description

## 🐛 Reporting Bugs

1. Ensure the bug was not already reported by searching on GitHub under [Issues](https://github.com/keep-starknet-strange/cashubrew/issues)
2. If you're unable to find an open issue addressing the problem, [open a new one](https://github.com/keep-starknet-strange/cashubrew/issues/new)

## 💡 Suggesting Enhancements

1. Check the [Issues](https://github.com/keep-starknet-strange/cashubrew/issues) page to see if the enhancement has already been suggested
2. If not, [create a new issue](https://github.com/keep-starknet-strange/cashubrew/issues/new), clearly describing the enhancement and its potential benefits

## 📜 Commit Message Guidelines

- Use the present tense ("Add feature" not "Added feature")
- Use the imperative mood ("Move cursor to..." not "Moves cursor to...")
- Limit the first line to 72 characters or less
- Reference issues and pull requests liberally after the first line

## ❓ Questions?

Don't hesitate to reach out if you have any questions.

Thank you for contributing to Cashubrew! 🚀✨
