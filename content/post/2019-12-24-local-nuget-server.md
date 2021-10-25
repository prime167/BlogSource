---
title: "局域网搭建私有nuget服务器"
date: 2019-12-24T15:09:29+08:00
tags: ["nuget",".NET"]
categories: ["技术"]
draft: false
---
昨天在公司局域网搭建了一个nuget服务器，记录一下过程<!--more-->

## 目的
首先，在本地搭建服务器的目的不是在本地复制一个 nuget.org，而是为了解决公司内部常用类库的分发问题。

目前公用代码主要有两种分发方式：

## 传统类库分发方式
### 源代码方式
在解决方案中直接添加类库的项目文件，再在需要的项目中添加引用

* 优点：便于调试

* 缺点：需要根据引用路径存放代码。

类库与使用它的代码通常不在一个源代码版本库里。假设Solution1 以这种方式引用了Lib1，新的开发克隆了Solution1之后打开，Lib1很大可能是不可用状态，打开引用Lib1的项目文件,可能会看到这样的代码：
```
...
   <ItemGroup>
    <ProjectReference Include="..\..\..\..\PC_Shared\Utils\PC.Shared.csproj">
...
```
新开发必须据此规划路径并克隆Lib1

### 以DLL方式分发
Lib1的负责人编译出dll，使用的人放到Solution1下的lib文件夹下，项目中再引用dll。

* 优点：部署引用简单

* 缺点：版本不易维护

## 部署
我选择了官方的Nuget.Server,部署起来非常简单

1. 新建基于 .NET Framework 的空白 ASP.NET Web 应用程序
2. 通过NuGet包管理器添加Nuget.Server包
3. 发布
4. 部署到IIS
5. 浏览器中打开，看到下图就表示成功了 

    ![nn](/images/local-nuget-iis-browser.png)
6. 编辑 Web.config
    ```
        <!--
    Determines if an Api Key is required to push\delete packages from the server. 
    -->
    <add key="requireApiKey" value="true" />

    <!-- 
    Set the value here to allow people to push/delete packages from the server.
    NOTE: This is a shared key (password) for all users.
    -->
    <add key="apiKey" value="your api key" />
    ```
## Visual Studio 添加程序包源
工具 => 选项 => NuGet包管理器 => 程序包源,点击右侧加号添加源

* 名称随便写，比如local
* 源写上一步配置好的地址，如 http://192.168.13.96:9006/nuget
* 点击确定

## 测试
1. 随便找个NuGet包，放到IIS路径下的Packages文件夹下，服务器会自动解析包，并生成文件夹结构。
2. 打开包管理器，源选择local，搜索刚才的包名字，是不是出现在搜索结果里了？
## 创建NuGet包
目前可以通过3种方式创建一个NuGet包：

### 1 通过NuGet命令行
这种方法适用于传统的基于 .NET Framework的类库

1. 从 nuget.org 下载最新版本nuget.exe, 放到合适的路径，并添加到 PATH 环境变量

2. 生成包元数据文件

    在类库.csproj 文件目录下打开命令行，运行
    ```
    nuget spec ClassLibrary1.csproj
    ```
    在目录下会生成一个 ClassLibrary1.nuspec，用文本编辑器打开，会看到如下内容：
    ```xml
    <?xml version="1.0" encoding="utf-8"?>
   <package>
        <metadata>
            <id>$id$</id>
            <version>$version$</version>
            <title>$title$</title>
            <authors>$author$</authors>
            <owners>$author$</owners>
            <requireLicenseAcceptance>false</requireLicenseAcceptance>
            <license type="expression">MIT</license>
            <projectUrl>http://project_url_here_or_delete_this_line/</projectUrl>
            <iconUrl>http://icon_url_here_or_delete_this_line/</iconUrl>
            <description>$description$</description>
            <releaseNotes>Summary of changes made in this release of the package.</releaseNotes>
            <copyright>Copyright 2019</copyright>
            <tags>Tag1 Tag2</tags>
            <dependencies>
                <group targetFramework=".NETFramework4.8"/>
            </dependencies>
        </metadata>
   </package>
    ```
    id 唯一标识 version 版本号(SemVer),如 1.0.0 其他的根据情况填写，$xxx$的为必填项。
3. 生成NuGet包 在类库.csproj 文件目录下打开命令行，运行
    ```
    nuget pack
    ```
    就会生成格式为id.version.nupkg的包了，其实就是一个zip格式的文件，可以添加.zip后缀解压查看。
### 2. 使用 dotnet 命令行创建
1. 编辑项目文件
    ```xml
    <Project Sdk="Microsoft.NET.Sdk">
        <PropertyGroup>
            <TargetFramework>netcoreapp3.1</TargetFramework>
            <!--添加以下内容-->
            <GeneratePackageOnBuild>true</GeneratePackageOnBuild>
            <PackageId>myLib2</PackageId>
            <Version>1.0.1</Version>
            <Authors>your_name</Authors>
            <Company>your_company</Company>
        </PropertyGroup>
    </Project>
    ```
2. 在类库.csproj 文件目录下打开命令行，运行如下命令生成包
    ```
    dotnet pack
    ```
### 3. 使用 Visual Studio 创建
适用于基于.NET Core 或者 .NET Standard 的类库，在项目属性，打包界面填入必须的信息，勾选 “在构建时生成NuGet包” 就会在输出文件夹生成包了。
    ![qq](/images/vspack.png)

### 4.通过 NuGet Package Explorer 创建
和第一种类似，只不过是GUI的方式。

1. Create Package
2. Edit Package Metadata
3. Add Package Content
## 发布NuGet包
四种方法

1. NuGet 命令行
    ```
    nuget push packagename yourapikey -Source http://192.168.13.96:9006/nuget
    ```
2. dotnet 命令行
    ```
    dotnet nuget push packagename yourapikey -s http://192.168.13.96:9006/nuget
    ```
3. NuGet Package Explorer

4. 如果有权限，当然可以直接把包拷贝到服务器

## 设置默认source
老是输入api key和 推送目的地址也是挺繁琐的，可以根据实际情况将配置添加到

1. 用户级的nuget.config(%appdata%/nuget/nuget.config)
    ```
    <?xml version="1.0" encoding="utf-8"?>
    <configuration>
        <config>
            <add key="defaultPushSource" value="http://192.168.13.96:9006/nuget" />
        </config>
        <packageRestore>
            <add key="enabled" value="True" />
            <add key="automatic" value="True" />
        </packageRestore>
        <activePackageSource>
            <add key="nuget.org" value="https://api.nuget.org/v3/index.json" />
        </activePackageSource>
        <packageSources>
            <add key="nuget.org" value="https://api.nuget.org/v3/index.json" protocolVersion="3" />
            <add key="nuget.org" value="https://www.nuget.org/api/v2/" />
            <add key="local" value="http://192.168.13.96:9006/nuget" />
            <add key="Microsoft Visual Studio Offline Packages" value="C:\Program Files (x86)\Microsoft SDKs\NuGetPackages\" />
        </packageSources>
        <apikeys>
            <add key="http://192.168.13.96:9006/nuget" value="AQAAANCMnd8BFdERjHoAwE/Cl+sBAAAAZ05kAjZLg06Fp2kByyoGSQAAAAACAAAAAAAQZgAAAAEAACAAAADhe1QaKTEA1JzEKcUxrpKBUV8g0eMEN1qYmkPBex3JPAAAAAAOgAAAAAIAACAAAABVYU2JJIULSVYt7/pIytWRl6CWm6m/QsIyi+x+az8N3BAAAAAUEQGJoa8+exi85xKZcPW6QAAAAKMWHIZoaecy/NA+TfOIc1obyhgtnQVk2rv3RJkAva1D/+w5NrRlUMkzwVRkgSHffEexPPHVNbAnvad7N/HEF1c=" />
        </apikeys>
    </configuration>
    ```
apikey 是加密的，需要通过命令行添加：
```
    nuget setapikey yourapikey -source http://192.168.13.96:9006/nuget
    nuget config -Set DefaultPushSource=http://192.168.13.96:9006/nuget
```
2. 或者你既维护nuget.org上的公共包，又维护自己公司的私有包，那可以在两个包的解决方案下放不同的nuget.conifg, 里面设置相应的defaultPushSource 和apikey 即可(当前目录为解决方案文件夹)

```
nuget setapikey yourapikey -source http://192.168.13.96:9006/nuget -configfile nuget.config

nuget config -Set DefaultPushSource=http://192.168.13.96:9006/nuget -configfile nuget.config
```
之后发布包，只需要执行
```
nuget push packagename
```
## 参考
* [NuGet 官方文档](https://docs.microsoft.com/en-us/nuget/)