# Stage 1: Build the Next.js app
FROM node:18.18.0-bullseye AS builder
LABEL authors="sanathwaghela"
WORKDIR /app

ENV BUILD_STANDALONE "true"
# ENV NODE_ENV "development"

# Copy package.json and package-lock.json to the working directory
COPY package*.json ./

# Install dependencies
RUN npm ci

# Copy the rest of the application code to the working directory
COPY . .

# Build the Next.js app
RUN npm run build


# Stage 2: Create the production-ready image using distroless
FROM gcr.io/distroless/nodejs18-debian11

WORKDIR /app


# Copy only the necessary files from the builder stage
COPY --from=builder /app/.next/standalone ./standalone
COPY --from=builder /app/.next/static  ./standalone/.next/static
#COPY --from=builder /app/.env.development ./standalone
COPY --from=builder /app/public  ./standalone/public


EXPOSE 3000

CMD ["standalone/server.js"]
