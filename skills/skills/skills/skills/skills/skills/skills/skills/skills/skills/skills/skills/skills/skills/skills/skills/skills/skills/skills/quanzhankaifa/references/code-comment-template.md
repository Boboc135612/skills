# 代码注释模板（中文）

> 适用于后端/前端/脚本。按语言选择注释风格（`//`、`#`、`/* */`、`/** */`）。

## 文件/模块头（推荐）
/*
 * 目的:
 * 责任边界:
 * 依赖:
 * 主要流程:
 * 关键约束:
 * 变更记录(可选):
 */

## 类/接口（推荐）
/**
 * 责任:
 * 关键字段:
 * 关键方法:
 * 并发/线程安全:
 * 约束:
 */

## 方法/函数（必填）
/**
 * 目的:
 * 输入:
 * 输出:
 * 副作用:
 * 异常/错误:
 * 边界条件:
 */

## 复杂逻辑块（必填）
// 关键逻辑:
// 为什么这样做:
// 依赖的前置条件/不变量:
// 可能的替代方案:

## 数据校验/安全/权限（按需）
// 校验规则:
// 安全/权限假设:
// 失败处理:

## 性能/资源（按需）
// 复杂度:
// 资源消耗:
// 优化点:

## TODO/风险（按需）
// TODO:
// 风险:

---

# Java 注释模板（Javadoc 风格）

## 单行/多行注释示例
// 单行注释
String type = "单行注释";

/*
 * 多行注释
 */
String type = "多行注释";

## 类注释模板
/**
 * @Title: ${file_name}
 * @Package ${package_name}
 * @Description: ${todo}(用一句话描述该文件做什么)
 * @author
 * @date ${date} ${time}
 * @version V1.0
 */
public class Dummy {}

/**
 * @ClassName: ${type_name}
 * @Description: ${todo}(这里用一句话描述这个类的作用)
 * @author
 * @date ${date} ${time}
 *
 * ${tags}
 */

## 字段注释模板
/**
 * @Fields ${field} : ${todo}(用一句话描述这个变量表示什么)
 */

## 方法注释模板
/**
 * @Title: ${enclosing_method}
 * @Description: ${todo}(这里用一句话描述这个方法的作用)
 * @param ${tags}  参数说明
 * @return ${return_type}    返回类型
 * @throws
 */

## 覆盖/实现方法的说明（按需）
/*
 * Title: ${enclosing_method}
 * Description:
 * ${tags}
 * ${see_to_overridden}
 */

## Spring 接口/DTO/Entity（MyBatis-Plus）

### Controller 接口方法（按需）
/**
 * @Title: ${enclosing_method}
 * @Description: ${todo}(接口用途)
 * @param ${tags}  参数说明
 * @return ${return_type}    返回说明
 * @throws
 */

### DTO（请求/响应对象）
/**
 * @ClassName: ${type_name}
 * @Description: ${todo}(DTO 用途)
 */
public class DummyDto {
  /**
   * @Fields ${field} : ${todo}(字段含义/格式/约束)
   */
}

### VO（视图/返回对象）
/**
 * @ClassName: ${type_name}
 * @Description: ${todo}(VO 用途)
 */
public class DummyVo {
  /**
   * @Fields ${field} : ${todo}(字段含义/展示规则/格式)
   */
}

### Query（查询条件对象）
/**
 * @ClassName: ${type_name}
 * @Description: ${todo}(查询条件用途)
 */
public class DummyQuery {
  /**
   * @Fields ${field} : ${todo}(查询字段/范围/排序说明)
   */
}

### Entity（MyBatis-Plus 实体）
/**
 * @ClassName: ${type_name}
 * @Description: ${todo}(实体对应表: ${table_name})
 */
public class DummyEntity {
  /**
   * @Fields ${field} : ${todo}(字段含义/数据类型/约束)
   */
}

### Mapper（接口注解/继承 BaseMapper）
/**
 * @ClassName: ${type_name}
 * @Description: ${todo}(Mapper 职责/表名)
 */
public interface DummyMapper extends BaseMapper<DummyEntity> {
  /**
   * @Title: ${enclosing_method}
   * @Description: ${todo}(自定义查询/变更用途)
   * @param ${tags}  参数说明
   * @return ${return_type}    返回说明
   */
}

### Mapper（接口 + XML 映射）
/**
 * @ClassName: ${type_name}
 * @Description: ${todo}(Mapper 职责/表名)
 */
public interface DummyMapper {
  /**
   * @Title: ${enclosing_method}
   * @Description: ${todo}(对应 XML 的 SQL 用途)
   * @param ${tags}  参数说明
   * @return ${return_type}    返回说明
   */
}

### Service 接口
/**
 * @ClassName: ${type_name}
 * @Description: ${todo}(Service 职责/业务域)
 */
public interface DummyService {
  /**
   * @Title: ${enclosing_method}
   * @Description: ${todo}(业务能力/使用场景)
   * @param ${tags}  参数说明
   * @return ${return_type}    返回说明
   * @throws
   */
}

### ServiceImpl 实现类
/**
 * @ClassName: ${type_name}
 * @Description: ${todo}(Service 实现说明/依赖)
 */
public class DummyServiceImpl implements DummyService {
  /**
   * @Title: ${enclosing_method}
   * @Description: ${todo}(实现细节/关键逻辑)
   * @param ${tags}  参数说明
   * @return ${return_type}    返回说明
   * @throws
   */
}

### Mapper XML（SQL 语句块说明）
<!--
  id: ${statement_id}
  用途: ${todo}(SQL 目的/业务含义)
  关键条件: ${tags}
  返回映射: ${return_type}
-->

### Controller 类注释（Spring MVC）
/**
 * @ClassName: ${type_name}
 * @Description: ${todo}(Controller 负责的业务域/模块)
 * @RequestMapping: ${base_path}
 */
public class DummyController {
  /**
   * @Title: ${enclosing_method}
   * @Description: ${todo}(接口用途/业务场景)
   * @param ${tags}  参数说明
   * @return ${return_type}    返回说明
   */
}

### 异常类注释
/**
 * @ClassName: ${type_name}
 * @Description: ${todo}(异常场景/触发条件)
 */
public class DummyException extends RuntimeException {
  /**
   * @Fields ${field} : ${todo}(错误码/错误信息)
   */
}

### 配置类注释
/**
 * @ClassName: ${type_name}
 * @Description: ${todo}(配置用途/生效范围)
 */
public class DummyConfig {
  /**
   * @Title: ${enclosing_method}
   * @Description: ${todo}(Bean/配置项用途)
   * @return ${return_type}    返回说明
   */
}

### 定时任务注释
/**
 * @ClassName: ${type_name}
 * @Description: ${todo}(定时任务用途/频率)
 */
public class DummyJob {
  /**
   * @Title: ${enclosing_method}
   * @Description: ${todo}(任务逻辑/执行窗口)
   * @throws
   */
}
