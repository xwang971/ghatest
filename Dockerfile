### Build and Test the App
FROM mcr.microsoft.com/dotnet/sdk:6.0-alpine AS build

### copy the source and tests
COPY . /src

WORKDIR /src

# build the app
RUN dotnet publish -c Debug -o /app

###########################################################


### Build the runtime container
FROM mcr.microsoft.com/dotnet/aspnet:6.0-alpine AS release

### if port is changed, also update value in Config
EXPOSE 8080
ENV ASPNETCORE_URLS=http://*:8080
WORKDIR /app

### copy the app
COPY --from=build /app .

ENTRYPOINT [ "dotnet",  "myWebApp.dll" ]
