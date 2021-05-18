FROM mcr.microsoft.com/dotnet/sdk:5.0-alpine as base
WORKDIR /opt/blogifier
ENV PATH="$PATH:/root/.dotnet/tools"
RUN apk update && apk add openjdk11 && \
    dotnet tool install --global dotnet-sonarscanner && \
    dotnet tool install --global coverlet.console --version 1.7.1

RUN dotnet sonarscanner begin \
    /k:"blogifier" \
    /d:sonar.host.url="http://localhost:9000" \
    /d:sonar.login="82eb2340e9928dfb9c3c39abb964a6620831df8e" \
    /d:sonar.cs.opencover.reportsPath=coverage.opencover.xml


# Copy everything else and build
COPY ./ /opt/blogifier
WORKDIR /opt/blogifier

RUN dotnet restore -v m
RUN dotnet build -c --no-restore -c Release --nologo
RUN dotnet publish -c Release -o outputs ./src/Blogifier/Blogifier.csproj

RUN coverlet ./tests/Blogifier.Tests/bin/Release/net5.0/Blogifier.Tests.dll \
    --target "dotnet" --targetargs "test -c Release --no-build" --format opencover

RUN dotnet sonarscanner end /d:sonar.login="82eb2340e9928dfb9c3c39abb964a6620831df8e"

#RUN ["dotnet","publish","./src/Blogifier/Blogifier.csproj","-o","./outputs" ]

# Build Runtime image
FROM mcr.microsoft.com/dotnet/aspnet:5.0-alpine as run
COPY --from=base /opt/blogifier/outputs /opt/blogifier/outputs 
WORKDIR /opt/blogifier/outputs
ENTRYPOINT ["dotnet", "Blogifier.dll"]
EXPOSE 88