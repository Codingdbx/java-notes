# git 使用教程

## 1. git常用命令

### 1.1 查看命令

- git branch -v  //查看本地仓库
- git branch -r   //查看远程仓库
- git branch -a  //查看所有分支
- git checkout dev  //切换分支

### 1.2 分支处理

#### 新建分支

- git checkout -b dev    //新建本地分支
- git push origin dev:dev  //把新建的本地分支push到远程服务器。
- git push origin       :dev        //删除远程分支，推送一个空分支到远程分支，其实就相当于删除远程分支
- git push origin --delete dev   //也可以使用删除

#### 拉取分支

- git remote update origin --prune  //获取远程分支记录
- git branch dev  origin/dev   //拉取远程dev分支
- git checkout dev  //切换到dev分支

#### 合并分支

- git checkout master //切换到master分支
- git merge dev  //合并dev到master

#### 缓存存储

- git stash save "save message"  //执行存储并添加备注
- git stash list  //查看stash了哪些存储
- git stash apply `stash@{0}` //应用某个存储，但不会把存储从列表中删除
- git stash pop  `stash@{0}` //恢复之前的存储，并删除缓存堆栈中对应的stash

#### 还原所有修改

-  git reset --hard

### 1.3 更换远程创库

- git remote rm origin  //移除旧仓库地址
- git remote add origin  //添加新远程仓库地址

### 1.4 设置用户信息

- git config --global user.name "dbx"            //给自己起个用户名
- git config --global user.email "dbx@gmail.com"        //填写自己的邮箱
- git config --list                                          //查看信息是否设置成功



## 2. 配置秘钥

### 2.1 生成ssh-key   

- `ssh-keygen -t rsa -C "kumar@qq.com"`   

![1610772148734](C:\Users\Dongbixi\AppData\Roaming\Typora\typora-user-images\1610772148734.png)

### 2.2 配置ssh

将 `id_rsa.pub` 文件的秘钥复制到 GitHub 上。