# --- Base Stage ---
# Use a slim and recent official Node.js runtime as a parent image.
# Using a specific version tag (e.g., 20-slim) is better for stability than using 'latest'.
FROM node:20-slim

# Install pnpm globally using npm, which comes with the Node image.
RUN npm install -g pnpm

# --- Dependencies Stage ---
# Create and set the working directory inside the container.
WORKDIR /app

# Copy the package.json and the pnpm lock file.
# By copying these first, Docker can cache the dependency installation layer.
# This layer will only be rebuilt if these files change, speeding up subsequent builds.
COPY package.json pnpm-lock.yaml ./

# Install project dependencies using pnpm.
# Using --frozen-lockfile is a best practice for CI/CD and Docker builds.
# It ensures that pnpm installs the exact versions specified in pnpm-lock.yaml.
# We are only installing production dependencies to keep the final image smaller.
RUN pnpm install

# --- Build & Run Stage ---
# Copy the rest of your application's source code.
COPY . .

# Expose the port that your application runs on.
# The 'pnpm dev' command often defaults to port 3000 for frameworks like Next.js or Vite.
# IMPORTANT: Change '3000' if your application uses a different port.
EXPOSE 3000

# The command to run your application.
# This will start the development server.
CMD ["pnpm", "dev"]
