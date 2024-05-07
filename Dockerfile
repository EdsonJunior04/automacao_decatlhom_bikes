FROM alpine:latest as builder

# Instalando dependências
RUN apk add --no-cache wget unzip curl build-base libffi-dev openssl-dev

# Instalando Terraform
RUN wget https://releases.hashicorp.com/terraform/1.8.2/terraform_1.8.2_linux_amd64.zip && \
    unzip terraform_1.8.2_linux_amd64.zip && \
    mv terraform /usr/local/bin/ && \
    rm terraform_1.8.2_linux_amd64.zip

# Configurando diretório de trabalho
WORKDIR /work

# STAGE 2: Final
FROM alpine:latest

WORKDIR /work

COPY app/ .

# Copiando binários e arquivos da STAGE 1
COPY --from=builder /usr/local/bin/terraform /usr/local/bin/terraform
COPY --from=builder /work /work

RUN apk add --no-cache aws-cli



# Copiando credenciais da AWS
ARG AWS_ACCESS_KEY_ID
ARG AWS_SECRET_ACCESS_KEY
ARG AWS_DEFAULT_REGION
ARG AWS_SESSION_TOKEN

RUN mkdir aws
RUN touch aws/credentials
RUN echo "[default]" >> aws/credentials && \
    echo "aws_access_key_id = $AWS_ACCESS_KEY_ID" >> aws/credentials && \
    echo "aws_secret_access_key = $AWS_SECRET_ACCESS_KEY" >> aws/credentials && \ 
    echo "aws_session_token = $AWS_SESSION_TOKEN" >> aws/credentials


RUN terraform init

# Configurando o diretório de trabalho


# Expondo a porta 8080
EXPOSE 8080

# Executando a aplicação
