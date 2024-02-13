FROM node:18.16-alpine

WORKDIR /app

COPY build/ package.json /app/

RUN npm install --omit=dev

EXPOSE 3000

CMD ["npm", "start"]