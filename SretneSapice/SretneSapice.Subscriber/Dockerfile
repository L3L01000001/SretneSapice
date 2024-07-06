#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS base
WORKDIR /app

FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /src
COPY ["SretneSapice.Subscriber/SretneSapice.Subscriber.csproj", "SretneSapice.Subscriber/"]
RUN dotnet restore "SretneSapice.Subscriber/SretneSapice.Subscriber.csproj"

FROM build AS publish
RUN dotnet publish "SretneSapice/SretneSapice.csproj" -c Release -o /app/publish
COPY . .
WORKDIR "/src/SretneSapice.Subscriber"
RUN dotnet build "SretneSapice.Subscriber.csproj" -c Release -o /app/build

FROM build AS publish
EUN dotnet publish "SretneSapice.Subscriber.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "SretneSapice.Subscriber.dll"]