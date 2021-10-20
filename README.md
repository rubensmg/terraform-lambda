# Lambda Function Deploy with Terraform

Esse repositório é um template de Terraform para agrupar e realizar o deploy de múltiplas funções lambdas de python no mesmo repositório.

## Definição do wrapper

O wrapper encapsula os seguintes módulos com base na sua responsabilidade:

- `role`: Responsável por criar a role e a policies necessárias para todas as Lambdas Functions descritas no repositório:
  - Role `rle-projeto-cliente` no namespace `/custom/cliente/projeto/`;
  - Policy `plc-projeto-cliene` no namespace `/custom/cliente/projeto/`; 
- `log`: Responsável por criar o log group no cloudwatch para a Lambda Function:
  - Log Group `/aws/lambda/funcao`;
- `package`: Responsável por gerar um pacote .zip para com o conteúdo de cada diretório que define cada Lambda Function:
  - Arquivo local `funcao.zip`;
- `function`: Cria cada Lambda Function utilizando os recursos criados nos outros módulos:
  - Lambda Function `funcao-projeto-cliente`;

## Como utilizar?

Será utilizado o repositório `meurepositorio` para fins de explicação. O `meurepositorio` contém a seguinte estrutura:

```
meurepositorio
│   configuration.tfvars    
│
└───function11
│   │   main.py
│   │
│   
└───function2
    │   main.py
    |
```

### function1 e function2

Contém o código fonte que será enviado para a Lambda Function respectiva. Para fins de exemplo, será utilizado o seguinte código:

```python
def handler(event, context):
    print('this is a function')
```

### configuration.tfvars

Contém a configuração de deploy das lambdas, onde cada parâmetro será explicado no exemplo abaixo:

```tfvars
# Nome do projeto a qual pertence o conjunto de funções (servindo apenas para marcar com tags os elementos)
project = "myproject" 

# Nome od cliente a qual pertence o conjunto de funções (servindo apenas para marcar com tags os elementos)
client  = "myclient"

# Definição de todas as funções que devem subir para a Lambda Function, onde:
#  - name: Nome da função (que ao final ficará "{name}-{project}-{client}")
#  - path: Diretório no repositório em que o código da função se encontra (como por exemplo, function1)
#  - handler: Arquvio/função que será executado quando a função for invocada (nomearquivo.nomefuncao)
#  - memory: Quantidade de memória que será alocada na execução da função
#  - timeout: Quantidade máxima de tempo em que a função será executada
#  - python_version: Versão do Python que será executada na função 
functions = [
  {
    name           = "function1"
    path           = "function1"
    handler        = "main.handler"
    memory         = 128
    timeout        = 10
    python_version = "3.6"
  },
  {
    name           = "anotherfunction"
    path           = "function2"
    handler        = "main.handler"
    timeout        = 10
    memory         = 128
    python_version = "3.6"
  }
]
```

### Configuração do pipeline

Para a criação do pipeline de deploy, fora utilizado uma ferramenta hipotética de deploy, que basicamente cria um pipeline para um repositório. No caso, o repositório que disparará esse pipeline será o `meurepositorio` (descrito acima).


```shell
# Instalar o terraform
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common curl
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install terraform

# Baixar o repositório wrapper do terraform
git clone https://github.com/rubensmg/terraform-lambda.git

# Acessar o repositorio
cd terraform-lambda/

# Definir as variáveis de ambiente da AWS
export AWS_DEFAULT_REGION="us-east-1" 
export AWS_ACCESS_KEY="myaccesskey"
export AWS_SECRET_ACCESS_KEY="secretaccesskey"

# Definir as variáveis contendo as configurações para o wrapper do terraform
export REPOSITORY="meurepositorio" # Nome do repositório (evitar caracteres especiais pois será utilizado como nome do arquivo de estados do terraform)
export AWS_BUCKET="meubucket" # Nome do bucket na qual encontram-se todos os arquivos de estado do terraform

# Comando para realizar o deploy
make deploy
```

## Como excluir

Após os testes, é possível eliminar todo o ambiente através dos comandos:

```shell
# Instalar o terraform
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common curl
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install terraform

# Clonar o repositório que reflete o ambiente na qual será excluído
git clone meurepositorio

# Acessar o repositorio
cd meurepositorio/

# Baixar o repositório wrapper do terraform
git clone https://github.com/rubensmg/terraform-lambda.git

# Acessar o repositorio
cd terraform-lambda/

# Definir as variáveis de ambiente da AWS
export AWS_DEFAULT_REGION="us-east-1" 
export AWS_ACCESS_KEY="myaccesskey"
export AWS_SECRET_ACCESS_KEY="secretaccesskey"

# Definir as variáveis contendo as configurações para o wrapper do terraform
export REPOSITORY="meurepositorio" # Nome do repositório (evitar caracteres especiais pois será utilizado como nome do arquivo de estados do terraform)
export AWS_BUCKET="meubucket" # Nome do bucket na qual encontram-se todos os arquivos de estado do terraform

# Comando para realizar o delete de todo o ambiente
make drop
```