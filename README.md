# golem

So far simple program which asks openai things on your behalf. Intended as a small executable to be encorporated into more complex workflows like node-red or huginn.

## Installation
1. Clone the repo
2. `bundle`
3. create a .env file with `OPENAI_API_KEY=` and your access_token.

## Usage
```
bin/golem ask "Which japanese whisky has a taste of green apple?"
bin/golem summarize "https://www.some.article.com/article"
```
