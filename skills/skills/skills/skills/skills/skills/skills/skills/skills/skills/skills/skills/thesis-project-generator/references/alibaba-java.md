# 阿里巴巴Java开发规范摘要

基于《阿里巴巴Java开发手册》整理的核心规范，用于指导代码生成。

## 目录
1. [命名规范](#命名规范)
2. [常量定义](#常量定义)
3. [代码格式](#代码格式)
4. [OOP规范](#oop规范)
5. [集合处理](#集合处理)
6. [异常处理](#异常处理)
7. [MySQL规范](#mysql规范)
8. [工程结构](#工程结构)

## 命名规范

### 基本规则

| 类型 | 规范 | 正例 | 反例 |
|------|------|------|------|
| 类名 | UpperCamelCase | UserService | userService |
| 方法名 | lowerCamelCase | getUserById | GetUserById |
| 变量名 | lowerCamelCase | localValue | LocalValue |
| 常量名 | UPPER_SNAKE_CASE | MAX_COUNT | maxCount |
| 包名 | 全小写 | com.alibaba.open | com.alibaba.Open |

### 类命名规范

| 类型 | 命名规则 | 示例 |
|------|----------|------|
| 抽象类 | Abstract或Base开头 | AbstractClass |
| 异常类 | Exception结尾 | BusinessException |
| 测试类 | Test结尾 | UserServiceTest |
| 枚举类 | Enum结尾（可选） | StatusEnum |
| 工具类 | Utils或Util结尾 | StringUtils |

### 方法命名规范

| 场景 | 命名规则 | 示例 |
|------|----------|------|
| 获取单个对象 | get前缀 | getById() |
| 获取多个对象 | list前缀 | listByUserId() |
| 获取统计值 | count前缀 | countByStatus() |
| 插入 | save或insert前缀 | saveUser() |
| 删除 | remove或delete前缀 | removeById() |
| 修改 | update前缀 | updateById() |
| 判断 | is前缀（返回boolean） | isValid() |

### Service/DAO层命名

| 层 | 命名规则 | 示例 |
|---|---------|------|
| Service接口 | IXxxService | IUserService |
| Service实现 | XxxServiceImpl | UserServiceImpl |
| Mapper接口 | XxxMapper | UserMapper |
| POJO领域模型 | Xxx | User |
| 数据传输对象 | XxxDTO | UserDTO |
| 展示对象 | XxxVO | UserVO |

## 常量定义

### 魔法值禁止

```java
// 反例
if (status == 1) { ... }

// 正例
private static final int STATUS_ACTIVE = 1;
if (status == STATUS_ACTIVE) { ... }
```

### 常量类设计

```java
public class UserConstants {
    /** 用户状态：正常 */
    public static final int STATUS_NORMAL = 1;
    /** 用户状态：禁用 */
    public static final int STATUS_DISABLED = 0;

    private UserConstants() {}
}
```

## 代码格式

### 缩进与换行
- 使用4个空格缩进，禁止使用Tab
- 单行字符数限制不超过120
- 换行时，运算符与下文一起换行

### 空格规范
```java
// if/for/while/switch与括号之间加空格
if (flag) { ... }

// 二元运算符两边加空格
int result = a + b;

// 方法参数逗号后加空格
method(arg1, arg2, arg3);
```

### 大括号规范
```java
// 左大括号不换行
public void method() {
    if (condition) {
        // ...
    } else {
        // ...
    }
}
```

## OOP规范

### 访问修饰符
- 类成员变量声明顺序：static → public → protected → private
- 工具类私有构造方法，防止实例化

### equals与hashCode
```java
// 比较时常量放前面
"active".equals(status);

// 重写equals必须重写hashCode
@Override
public boolean equals(Object o) { ... }

@Override
public int hashCode() { ... }
```

### POJO类规范
```java
@Data
public class User {
    /** 用户ID */
    private Long id;

    /** 用户名 */
    private String username;

    // 禁止使用基本类型，使用包装类
    // 反例：private int age;
    private Integer age;

    // 不要设置默认值
    // 反例：private Integer status = 0;
    private Integer status;
}
```

## 集合处理

### 集合初始化
```java
// 指定集合初始容量
List<User> users = new ArrayList<>(100);
Map<String, User> userMap = new HashMap<>(16);
```

### 集合判空
```java
// 使用isEmpty()
if (list.isEmpty()) { ... }

// 或使用工具类
if (CollectionUtils.isEmpty(list)) { ... }
```

### 集合遍历
```java
// 使用增强for或Stream
for (User user : users) { ... }

users.stream()
     .filter(u -> u.getStatus() == 1)
     .collect(Collectors.toList());
```

## 异常处理

### 异常捕获
```java
// 不要捕获Exception，要捕获具体异常
try {
    // ...
} catch (IOException e) {
    log.error("读取文件失败", e);
    throw new BusinessException("文件读取失败");
}

// 禁止catch后不处理
// 反例
try { ... } catch (Exception e) { }
```

### 自定义异常
```java
public class BusinessException extends RuntimeException {
    private Integer code;
    private String message;

    public BusinessException(String message) {
        super(message);
        this.code = 500;
        this.message = message;
    }

    public BusinessException(Integer code, String message) {
        super(message);
        this.code = code;
        this.message = message;
    }
}
```

## MySQL规范

### 表设计规范

| 规范 | 说明 |
|------|------|
| 表名 | 小写字母，单词用下划线分隔 |
| 字段名 | 小写字母，单词用下划线分隔 |
| 主键 | 统一使用id，BIGINT UNSIGNED |
| 必备字段 | id, create_time, update_time |
| 禁止 | 使用MySQL保留字作为字段名 |

### 字段类型规范

| 数据 | 推荐类型 | 说明 |
|------|----------|------|
| 主键 | BIGINT UNSIGNED | 无符号大整数 |
| 金额 | DECIMAL(10,2) | 精确数值 |
| 状态 | TINYINT UNSIGNED | 0-255 |
| 时间 | DATETIME | 年月日时分秒 |
| 短文本 | VARCHAR(n) | 可变长度 |
| 长文本 | TEXT | 大文本 |
| 布尔 | TINYINT(1) | 0/1 |

### 索引规范

| 规范 | 命名格式 | 示例 |
|------|----------|------|
| 主键索引 | pk_字段名 | pk_id |
| 唯一索引 | uk_字段名 | uk_username |
| 普通索引 | idx_字段名 | idx_create_time |
| 联合索引 | idx_字段1_字段2 | idx_user_status |

### SQL规范
```sql
-- 禁止SELECT *
SELECT id, username, status FROM user WHERE id = 1;

-- 使用LIMIT限制
SELECT id, username FROM user LIMIT 100;

-- 避免在WHERE子句中使用函数
-- 反例
SELECT * FROM user WHERE DATE(create_time) = '2024-01-01';
-- 正例
SELECT * FROM user WHERE create_time >= '2024-01-01' AND create_time < '2024-01-02';
```

## 工程结构

### 分层规范

```
├── controller        # Web层，接收请求
├── service          # 业务层
│   └── impl         # 业务实现
├── mapper           # 持久层
├── entity           # 实体类
├── dto              # 数据传输对象
├── vo               # 视图对象
├── config           # 配置类
├── common           # 公共组件
│   ├── Result.java  # 统一返回
│   └── PageResult.java
├── exception        # 异常定义
└── utils            # 工具类
```

### 分层调用规范

```
┌────────────┐
│ Controller │  ← 只能调用Service
├────────────┤
│  Service   │  ← 可以调用其他Service和Mapper
├────────────┤
│   Mapper   │  ← 只能访问数据库
└────────────┘
```

### 返回值规范

| 层 | 返回类型 |
|---|---------|
| Controller | Result<T> |
| Service | Entity/VO/DTO/基本类型 |
| Mapper | Entity/List<Entity> |

### 统一返回格式

```java
@Data
public class Result<T> {
    private Integer code;
    private String message;
    private T data;

    public static <T> Result<T> success(T data) {
        Result<T> result = new Result<>();
        result.setCode(200);
        result.setMessage("success");
        result.setData(data);
        return result;
    }

    public static <T> Result<T> error(String message) {
        Result<T> result = new Result<>();
        result.setCode(500);
        result.setMessage(message);
        return result;
    }
}
```
