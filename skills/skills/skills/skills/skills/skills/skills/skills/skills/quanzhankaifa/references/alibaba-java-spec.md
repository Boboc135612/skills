# Alibaba Java Coding Guidelines - Detailed Checklist

This is a condensed, actionable checklist derived from the Alibaba Java Coding Guidelines.
It keeps rules grouped by section and includes short examples.

## Source Scope and Levels
- The guide has five parts: Programming Specification, Exception and Logs, MySQL Specification, Project Specification, and Security Specification.
- Rules are classified into three levels: Mandatory, Recommended, Reference.
- P3C provides the official PDF (Huangshan edition released 2022-02-03) and PMD/IDE tooling to enforce rules.

## 1) Programming Specification - Naming Conventions (Mandatory)
1. Names must not start or end with `_` or `$`.
   - Bad: `_name`, `name_`, `$Object`
2. Do not use Chinese/Pinyin/mixed spelling for identifiers; use accurate English.
   - OK: `alibaba`, `taobao`, `Hangzhou` (proper names in Pinyin are acceptable)
3. Class names use UpperCamelCase; domain models can use DO/BO/DTO/VO.
   - Good: `UserDO`, `OrderDTO`, `XmlService`
4. Method/param/field/local names use lowerCamelCase.
   - Good: `getHttpMessage`, `inputUserId`
5. Constants use ALL_CAPS with underscores and must be semantically clear.
   - Good: `MAX_STOCK_COUNT`
6. Abstract classes start with `Abstract` or `Base`; exception classes end with `Exception`; test classes end with `Test`.
   - Good: `AbstractUserService`, `OrderException`, `UserServiceTest`
7. Array brackets belong to the type.
   - Good: `String[] args` (Bad: `String args[]`)
8. Do not prefix boolean field names with `is` (serialization issues).
   - Bad: `boolean isSuccess;` (frameworks may map it to `success`)
9. Package names are lowercase, single English word per dot, and singular.
   - Good: `com.alibaba.open.util`
10. Avoid uncommon abbreviations for readability.
    - Bad: `condi` (Condition), `AbsClass` (AbstractClass)
11. Service/DAO should be interfaces; implementations end with `Impl`.
    - Good: `CacheService` + `CacheServiceImpl`
12. Enum class name ends with `Enum`, members are ALL_CAPS with underscores.
    - Good: `DealStatusEnum { SUCCESS, UNKNOWN_REASON }`

## 2) Exception and Logs
### Exceptions (Mandatory)
1. Do not catch JDK runtime exceptions like `NullPointerException`/`IndexOutOfBoundsException`; pre-check instead when possible.
2. Never use exceptions for normal control flow.
3. Do not wrap large code blocks in a single try-catch; separate stable vs. unstable code and catch specific exceptions.
4. Do not swallow exceptions; rethrow if not handled, and top layer must translate to user-friendly messages.
5. Ensure rollback on methods throwing Exception.
6. Close Closeable resources in finally or use try-with-resources; never throw exceptions from finally.

**Example (specific catch + rethrow + business message):**
```java
try {
    userRepository.save(user);
} catch (DuplicateKeyException e) {
    log.warn("User create failed, duplicate: userId={}", user.getId());
    throw new BizException("USER_EXISTS");
} catch (DataAccessException e) {
    log.error("DB error when creating user: userId={}", user.getId(), e);
    throw new BizException("DB_ERROR");
}
```

**Example (try-with-resources):**
```java
try (InputStream in = file.getInputStream()) {
    // process stream
} catch (IOException e) {
    log.error("Read file failed, fileId={}", fileId, e);
    throw new BizException("FILE_READ_ERROR");
}
```

### Logs (Recommended)
- Use WARN for invalid parameters; use ERROR for logic errors/critical failures.
- Use parameterized logging, avoid string concatenation.
- Do not log sensitive data (passwords, tokens, full ID numbers).
- Add traceId or requestId to logs (MDC).

**Example (parameterized log + MDC):**
```java
MDC.put("traceId", traceId);
log.info("Create order: orderId={}, userId={}", orderId, userId);
log.warn("Invalid param: userId={}", userId);
log.error("Payment failed: orderId={}", orderId, e);
```

## 3) MySQL Rules (Schema, Index, Transaction)
### Naming and Schema (Mandatory)
1. Boolean columns should be named `is_xxx` and use unsigned tinyint (1/0).
2. Table/column names must be lowercase letters, digits, underscores; do not start with digits or use patterns like `level_3_name`.
3. Table names must not be plural.
4. Do not use MySQL keywords (e.g., `desc`, `range`, `match`) as names.
5. Index naming: primary key `pk_`, unique `uk_`, normal index `idx_` + column name.

### Field Type Selection (Recommended)
- Use `bigint` for IDs; avoid `int` if you expect large growth.
- Use `decimal` for money; do not use `float`/`double` for money.
- Use `datetime`/`timestamp` for time; avoid `varchar` for time.
- Use `varchar` for short text with explicit length; use `text` for long text.
- Use `tinyint`/`smallint` for enums or status.

**Example (money and status):**
```sql
amount decimal(18,2) not null default 0.00,
status tinyint not null default 0,
```

### Index Rules (Recommended)
- Index columns should be highly selective and used in frequent query conditions.
- Follow the leftmost prefix rule for composite indexes.
- Avoid redundant indexes; keep index count under control.
- Avoid functions or calculations on indexed columns in WHERE.

**Example (composite index):**
```sql
create index idx_user_order_time on user_order (user_id, order_time);
```

### Transaction Rules (Recommended)
- Keep transactions small and short; avoid long-running transactions.
- Prefer row-level locks; avoid full table locks.
- Use appropriate isolation; avoid REPEATABLE-READ for long transactions unless required.
- Handle deadlocks with retry and clear error messages.

**Example (spring transactional):**
```java
@Transactional(rollbackFor = Exception.class)
public void placeOrder(OrderDTO dto) {
    // write operations
}
```

## 4) Project Specification (Layering, Logging Fields, Audit)
### Layering (Recommended)
- Upper layers should depend on lower layers by default.
- Typical layers: Open Interface, View, Web Layer, Service Layer (business logic), etc.
- Keep controller thin; business logic belongs to service; DAO only handles data access.

### Log Field Standard (Recommended)
- Always include: `traceId`, `userId`, `requestPath`, `method`, `status`, `costMs`.
- For business logs include: `bizId`, `bizType`, `result`.

**Example (structured log):**
```java
log.info("traceId={} userId={} path={} method={} status={} costMs={} bizId={} bizType={} result={}",
    traceId, userId, path, method, status, costMs, bizId, bizType, result);
```

### Audit Specification (Recommended)
- Keep immutable audit logs for key business actions (create/update/delete, approvals).
- Capture operator, time, before/after state, and reason.
- Do not allow audit logs to be modified by normal business flows.

**Example (audit event):**
```java
AuditEvent event = AuditEvent.of("ORDER_UPDATE", orderId)
    .operator(userId)
    .before(beforeJson)
    .after(afterJson)
    .reason("manual_fix")
    .occurredAt(new Date());

auditService.record(event);
```

## 5) Security Specification (Mandatory)
1. User-owned pages or functions must be authorized.
2. Do not display sensitive user data directly; always desensitize.
3. User SQL parameters must be validated/limited; SQL concatenation is forbidden.
4. All user inputs must be validated.
5. Do not output user data to HTML without proper escaping.
6. Form/AJAX submission must be protected by CSRF checks.

**Example (authz check):**
```java
if (!permissionService.canAccess(userId, resourceId)) {
    throw new BizException("NO_PERMISSION");
}
```

**Example (SQL injection safe, MyBatis):**
```xml
<select id="findById" parameterType="long" resultType="User">
  SELECT * FROM user WHERE id = #{id}
</select>
```

**Example (XSS escape at output):**
```java
String safe = HtmlUtils.htmlEscape(input);
```

## 6) Distributed Transactions (Recommended)
- Prefer eventual consistency: message-based or outbox pattern.
- If strong consistency is required, use 2PC or TCC with explicit compensation.
- Avoid long transactions across services; keep local transactions short and idempotent.

**Example (outbox table pattern):**
```sql
create table outbox_event (
  id bigint primary key,
  biz_id bigint not null,
  event_type varchar(64) not null,
  payload text not null,
  status tinyint not null default 0,
  created_at datetime not null
);
```

**Example (publish after local tx):**
```java
@Transactional(rollbackFor = Exception.class)
public void createOrder(OrderDTO dto) {
    orderRepository.save(order);
    outboxRepository.save(OutboxEvent.of("ORDER_CREATED", order.getId(), payload));
}
```

## Practical Usage in This Skill
- Add a "Coding Rules" section to architecture/module/DB/API docs and reference this checklist.
- In implementation plan, add a task: "Enable P3C and pass mandatory rules".

