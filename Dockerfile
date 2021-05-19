FROM mcr.microsoft.com/dotnet/sdk:5.0 as build

RUN mkdir /usr/share/man/man1/
RUN apt-get update && apt-get install -y openjdk-11-jdk

ENV PATH="$PATH:/root/.dotnet/tools"
RUN dotnet tool install --global dotnet-sonarscanner && \
    dotnet tool install --global coverlet.console

# Copy source code
COPY ./ /opt/blogifier
WORKDIR /opt/blogifier

# Running Sonar scan
RUN dotnet sonarscanner begin \
    /k:"mytestapp" \
    /d:sonar.host.url="http://localhost:9000" \
    /d:sonar.login="4c0734f1fa2e3ac6f4e0592c6b8b2bb277549fdc" \
    /d:sonar.cs.opencover.reportsPaths=coverage.opencover.xml

RUN dotnet restore -v m 
RUN dotnet build --no-restore --nologo

RUN dotnet publish ./src/Blogifier/Blogifier.csproj -o ./outputs

RUN coverlet /opt/blogifier/tests/Blogifier.Tests/bin/Debug/net5.0/Blogifier.Tests.dll --target "dotnet" --targetargs "test --no-build" --format opencover

RUN dotnet sonarscanner end /d:sonar.login="4c0734f1fa2e3ac6f4e0592c6b8b2bb277549fdc"


# Runtime image
FROM mcr.microsoft.com/dotnet/aspnet:5.0 as run
COPY --from=build /opt/blogifier/outputs /opt/blogifier/outputs
WORKDIR /opt/blogifier/outputs
ENTRYPOINT ["dotnet", "Blogifier.dll"]
EXPOSE 80
