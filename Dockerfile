FROM mcr.microsoft.com/dotnet/sdk:5.0 as base
WORKDIR /opt/blogifier
ENV PATH="$PATH:/root/.dotnet/tools"

RUN mkdir /usr/share/man/man1/

RUN apt-get update && apt-get install -y openjdk-11-jdk && \
    dotnet tool install --global dotnet-sonarscanner  && \
    dotnet tool install --global coverlet.console 

RUN dotnet sonarscanner begin \
    /k:"myapp" \
    /d:sonar.host.url="http://localhost:9000" \
    /d:sonar.login="5563e5fe77389ade9b4ed3a45420934ba33b5d0a" \
    /d:sonar.cs.opencover.reportsPath=coverage.opencover.xml

# Copy everything else and build
COPY ./ /app/blogifier
WORKDIR /app/blogifier

RUN dotnet restore -v m
RUN dotnet build --no-restore --nologo

RUN ["dotnet","publish","./src/Blogifier/Blogifier.csproj","-o","./outputs" ]


RUN coverlet /app/blogifier/tests/Blogifier.Tests/bin/Debug/net5.0/Blogifier.Tests.dll \ 
    --target "dotnet" --targetargs "test --no-build" --format opencover
    
RUN dotnet sonarscanner end /d:sonar.login="5563e5fe77389ade9b4ed3a45420934ba33b5d0a"

FROM mcr.microsoft.com/dotnet/aspnet:5.0 as run
COPY --from=base /app/blogifier/outputs /app/blogifier/outputs
WORKDIR /app/blogifier/outputs
ENTRYPOINT ["dotnet", "Blogifier.dll"]

EXPOSE 80