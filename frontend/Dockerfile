# Estágio de build
FROM node:18 as build

WORKDIR /app

# Copiar package.json e package-lock.json
COPY package*.json ./

# Instalar dependências
RUN npm install

# Copiar o restante dos arquivos
COPY . .

# Ambiente (desenvolvimento ou produção)
ARG NODE_ENV=development
ENV NODE_ENV=${NODE_ENV}

# Build para produção ou desenvolvimento
RUN if [ "$NODE_ENV" = "production" ] ; then npm run build --prod ; else npm run build ; fi

# Estágio de produção
FROM nginx:alpine

# Copiar configuração do nginx
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copiar build do estágio anterior
COPY --from=build /app/dist/frontend /usr/share/nginx/html

# Expor porta
EXPOSE 80

# Iniciar nginx
CMD ["nginx", "-g", "daemon off;"]
