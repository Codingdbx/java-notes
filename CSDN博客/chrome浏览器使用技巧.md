# chrome浏览器使用技巧

## 1. chrome浏览器快捷键

### 1.1 功能快捷键

| 操作                     | 快捷键                |
| ------------------------ | --------------------- |
| 刷新                     | F5                    |
| ==强制刷新==（缓存失效） | Ctrl+F5               |
| ==无痕浏览==             | Ctrl + Shift + n      |
| 显示或隐藏书签栏         | Ctrl + Shift + b      |
| 书签管理器               | Ctrl + Shift + o      |
| 历史记录页               | Ctrl + h              |
| 下载内容页               | Ctrl + j              |
| ==打印当前网页==         | Ctrl + p              |
| Chrome 任务管理器        | Shift + Esc           |
| 查找栏搜索当前网页       | Ctrl + f              |
| ==开发者工具==           | F12                   |
| ==清除浏览数据==         | Ctrl + Shift + Delete |
| Chrome 帮助中心          | F1                    |



## 2. 浏览器刷新原理  

浏览器是通过 Last-Modified 和 Expires 来处理缓存的。对于大多数浏览器而言，都包含有三种刷新方式。

### 2.1 刷新方式

- F5 刷新
  - 不允许浏览器直接使用本地缓存，因此 Last-Modified 能起作用，但 Expires 无效。

- Ctrl+F5 刷新
  - 是强制刷新，因此缓存机制失效。

- ”转至”或地址栏里回车刷新
  - 正常的访问，Last-Modified 和 Expires 都有效。

### 2.2 Last-Modified 和 Expires

- Last-Modified：服务器上文件的最后修改时间
- Etag：文件标识
- Expires：本地缓存目录中，文件过期的时间（由服务器指定具体的时间）
- Cache-control：用于控制HTTP缓存

注意：Expires 表示存在时间，允许客户端在这个时间之前不去检查（发请求），等同Cache-Control的max-age的效果。但是如果同时存在，则被Cache-Control的max-age覆盖。

### 2.3 重复提交问题

浏览器在刷新时，把上一次的post参数给记忆下来并重新传递给了服务器，不管在这个过程中你是否做什么样的改动，他一概不予理会，而是忠实的把上一次所有POST的参数原封不动的重新发送给服务器。   

