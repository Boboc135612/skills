#!/bin/bash

# 定义 Skills 列表
skills=(
    "jeecgboot-starter"
    "device-management-module"
    "database-design"
    "mybatis-debugging"
    "safety-training-workflow"
    "vue3-components"
    "thesis-ai-integration"
    "postgresql-optimization"
)

# 创建 skills 目录
mkdir -p skills

# 为每个 skill 创建结构
for skill in "${skills[@]}"; do
    skill_dir="skills/$skill"
    echo "Creating $skill_dir..."

    mkdir -p "$skill_dir/scripts"
    mkdir -p "$skill_dir/examples"
    mkdir -p "$skill_dir/references"

    # 创建 SKILL.md
    cat > "$skill_dir/SKILL.md" << ENDOFFILE
---
name: $skill
description: [需要填写描述]
---

# $(echo $skill | sed 's/-/ /g')

## 何时使用

## 快速开始

## 最佳实践

## 常见问题

## 相关资源
ENDOFFILE

    # 创建 .gitkeep
    touch "$skill_dir/scripts/.gitkeep"
    touch "$skill_dir/examples/.gitkeep"
    touch "$skill_dir/references/.gitkeep"
done

# 创建 README
cat > README.md << 'ENDREADME'
# Kris's Claude Code Skills

个人 Claude Code 技能库，用于 JeecgBoot 企业应用开发。

## 包含的 Skills

- **jeecgboot-starter** - JeecgBoot 项目快速启动指南
- **device-management-module** - 设备管理模块开发
- **database-design** - 数据库设计最佳实践
- **mybatis-debugging** - MyBatis 问题排查
- **safety-training-workflow** - 安全培训工作流
- **vue3-components** - Vue3 组件开发指南
- **thesis-ai-integration** - 论文 AI 集成方案
- **postgresql-optimization** - PostgreSQL 性能优化

## 使用方式

在 Claude Code 中使用：
```bash
git submodule add https://github.com/Boboc135612/skills.git shared-skills
```

Claude Code 会自动在 shared-skills/skills/ 下发现所有 Skills。
ENDREADME

# 创建 .gitignore
cat > .gitignore << 'ENDGIT'
.DS_Store
*.swp
*.swo
*~
.vscode/
.idea/
node_modules/
*.log
.env
.env.local
ENDGIT

echo "Done! Skills structure created successfully."
tree -L 2 skills/