---
title: "Visual Studio 解决方案文件格式拾遗"
date: 2020-06-12T16:28:28+08:00
tags: ["dotnet"]
categories: ["技术"]
draft: false
---
关于解决方案文件sln的说明，官方文档已经说的很清楚的，这里不再重复，只说几个细节的地方<!--more-->

一个完整的sln文件
```
Microsoft Visual Studio Solution File, Format Version 12.00
# Visual Studio 16
VisualStudioVersion = 16.7.30413.136
MinimumVisualStudioVersion = 10.0.40219.1
Project("{FAE04EC0-301F-11D3-BF4B-00C04F79EFBC}") = "MQTTnetServer", "MQTTnetServer\MQTTnetServer.csproj", "{B0C01277-BBF1-4A23-B700-4E4B6954A3B7}"
EndProject
Project("{FAE04EC0-301F-11D3-BF4B-00C04F79EFBC}") = "MQTTnetClient", "MQTTnetClient\MQTTnetClient.csproj", "{0CCD1198-FD33-48E7-8B5A-506135EAF0E4}"
EndProject
Global
	GlobalSection(SolutionConfigurationPlatforms) = preSolution
		Debug|Any CPU = Debug|Any CPU
		Release|Any CPU = Release|Any CPU
	EndGlobalSection
	GlobalSection(ProjectConfigurationPlatforms) = postSolution
		{B0C01277-BBF1-4A23-B700-4E4B6954A3B7}.Debug|Any CPU.ActiveCfg = Debug|Any CPU
		{B0C01277-BBF1-4A23-B700-4E4B6954A3B7}.Debug|Any CPU.Build.0 = Debug|Any CPU
		{B0C01277-BBF1-4A23-B700-4E4B6954A3B7}.Release|Any CPU.ActiveCfg = Release|Any CPU
		{B0C01277-BBF1-4A23-B700-4E4B6954A3B7}.Release|Any CPU.Build.0 = Release|Any CPU
		{0CCD1198-FD33-48E7-8B5A-506135EAF0E4}.Debug|Any CPU.ActiveCfg = Debug|Any CPU
		{0CCD1198-FD33-48E7-8B5A-506135EAF0E4}.Debug|Any CPU.Build.0 = Debug|Any CPU
		{0CCD1198-FD33-48E7-8B5A-506135EAF0E4}.Release|Any CPU.ActiveCfg = Release|Any CPU
		{0CCD1198-FD33-48E7-8B5A-506135EAF0E4}.Release|Any CPU.Build.0 = Release|Any CPU
	EndGlobalSection
	GlobalSection(SolutionProperties) = preSolution
		HideSolutionNode = FALSE
	EndGlobalSection
	GlobalSection(ExtensibilityGlobals) = postSolution
		SolutionGuid = {4E37268A-53FA-4F12-8CC2-3763A411C11E}
	EndGlobalSection
EndGlobal
```
VisualStudioVersion 的第二位始终是，不会随着版本的升级而改变，也就是在整个Visual Studio 2019 生命周期内，前两位始终是16.0。以下是微软官方的回应：

>$(VisualStudioVersion) is expected to be 16.0 for the full Visual Studio 2019 release cycle. This is somewhat confusing, but it is used to construct paths which have the same property: 16.0 for all Visual Studio 16.x.y

参考
* [Solution (.sln) file](https://docs.microsoft.com/en-us/visualstudio/extensibility/internals/solution-dot-sln-file?view=vs-2019)
* [Visual Studio build numbers and release dates](https://docs.microsoft.com/en-us/visualstudio/install/visual-studio-build-numbers-and-release-dates?view=vs-2019)
* [Visual Studio Release Notes](https://docs.microsoft.com/en-us/visualstudio/releases/2019/release-notes?view=vs-2019)
* [理解 Visual Studio 解决方案文件格式（.sln）](https://blog.walterlv.com/post/understand-the-sln-file.html)