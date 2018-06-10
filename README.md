# 懒虫脚本 | Lazy-script

## 简介 | Introduction

一个为懒虫打造的脚本工具箱。脚本类型包括但不限于`Shell`、`Expect`、`Perl`和`Python`。可用于管理你的系统、便于格式化及编译代码、信息搜索及提取、自定义测试，等等。

A script box for lazy guys. Script types include but are not limited to `Shell`, `Expect`, `Perl` and `Python`. It can help you manage your system, be convenient for code formatting and compilation, search for and extract information you need, do self-defined tests, etc.

***码少才能生活好！***

***Less code, better world!***

## 安装及卸载 | Installation and Uninstallation

### 受支持平台 | Supported Platforms

1. **Ubuntu**: 16.04 or above

2. `OS X`: untested ...

3. `Cygwin`: untested ...

### 依赖程序 | Dependencies

1. **bash**, `awk`, `sed` and `grep`

2. 安装及使用过程中提示需要的程序 | Programs printed on terminal during installation and daily use

### 操作步骤 | Steps

进入到该工具箱根目录，执行：

Enter root directory of this script box, run:

```
bash install_lazy_script.sh
```

即可进行安装。若要卸载，则执行：

the installation will start. If you want to uninstall it, run:

```
bash uninstall_lazy_script.sh
```

## 用法 | Usage

安装成功后，即可在终端使用工具箱里的脚本、函数、变量等，且可扩展，只需在`$LAZY_SCRIPT_HOME/details/private`及其子目录放入用户自定义的脚本文件，即可增加自己所需的新功能。

Scripts, functions, variables and other things can be used on terminal after successful installation. Besides, this script box is extendible, just put your own stuff in `$LAZY_SCRIPT_HOME/details/private` directory and its subdirectories and you can add your own functionalities.

***注意***：***请务必确保`bash`或其软／硬链接位于 /bin 目录下！*** 安装完成后，***要手动启动一个终端完成初始化！***

***NOTE***: ***Please make sure the `bash` program or its soft / hard link is in /bin directory!*** After installation, you have to ***start a terminal manually to initialize this script box!***

