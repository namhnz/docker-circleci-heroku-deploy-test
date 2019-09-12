FROM microsoft/dotnet:2.2-sdk AS build
WORKDIR /app

# Copy csproj and restore as distinct layers
COPY *.csproj ./
RUN dotnet restore

# Copy everything else and build
COPY . ./
RUN dotnet publish -c Release -o out

# Build runtime image
FROM microsoft/dotnet:2.2-aspnetcore-runtime
ENV PORT=5001
WORKDIR /app
COPY --from=build /app/out .
CMD ASPNETCORE_URLS=https://*:$PORT dotnet docker-circleci-heroku-deploy-test.dll