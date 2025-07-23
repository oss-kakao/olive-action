# OLIVE CLI Scanner Action

Kakao [OLIVE CLI](https://github.com/kakao/olive-cli)를 사용하여 소스코드 의존성을 분석합니다.  
분석된 결과를 [OLIVE Platform](https://olive.kakao.com/)에 적용해서 확인할 수 있습니다.  
또한 PR에 액션 수행 결과를 코멘트로 남겨서 확인할 수 있습니다.  
이 액션은 Docker 컨테이너 환경에서 [OLIVE CLI](https://github.com/kakao/olive-cli)를 실행하여 의존성을 분석하고, 결과를 아티팩트로 저장합니다.

## 사용법

### 기본 입력값

| 이름 | 설명 | 기본값 |
|------|------|--------|
| `olive-token` | [OLIVE Platform](https://olive.kakao.com/) API 토큰<br>[토큰 설정하기](https://olive.kakao.com/docs/my-page/token) 가이드를 참고해서 반드시 [GitHub Secrets](https://docs.github.com/ko/actions/how-tos/writing-workflows/choosing-what-your-workflow-does/using-secrets-in-github-actions)에 저장하여 사용하세요. | 필수 |
| `github-token` | PR에 코멘트를 작성하기 위한 GitHub 토큰<br>일반적으로 `${{ secrets.GITHUB_TOKEN }}`을 사용합니다. | 필수 |

### 기본 사용법 (PR 생성시 자동 실행)

```yaml
name: OLIVE CLI Scanner

on:
  pull_request:
    types: [opened, synchronize, reopened]
    branches:
      - develop
      - main

permissions:
  contents: read
  issues: write
  pull-requests: write

jobs:
  olive-scan:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v4

      - name: Run OLIVE CLI Scanner
        uses: kakao/olive-actions@v1
        with:
          olive-token: ${{ secrets.OLIVE_TOKEN }}
          github-token: ${{ secrets.GITHUB_TOKEN }}
```
### 출력값

| 이름 | 설명 |
|------|------|
| `olive-version` | 사용된 OLIVE CLI 버전 |
| `analysis-completed` | 분석 완료 여부 (true/false) |
| `artifact-urls` | 업로드된 아티팩트가 있는 GitHub Actions 실행 URL |

## 다양한 사용법 예시

### 선택 입력값

| 이름 | 설명 | 기본값 |
|------|------|--------|
| `olive-project-name` | Olive 프로젝트 이름 | 저장소 이름<br>(예: 'kakao/repo'의 경우 'repo') |
| `source-path` | 분석할 소스코드 경로 | `./` |
| `user-config-path` | 사용자 정의 config 파일(user-config.yaml) 경로<br>이 파일은 OLIVE CLI의 `-c` 옵션으로 전달되어 기본 설정을 오버라이드합니다. | `""` (사용하지 않음) |
| `artifact-retention-days` | 아티팩트 보관 기간(일) | `30` |
| `comment-on-pr` | PR에 코멘트 작성 여부 | `true` |
| `analyze-only` | 분석을 수행한 결과를 [OLIVE Platform](https://olive.kakao.com/)에 프로젝트를 생성해서 반영할지 여부<br>분석된 결과를 [OLIVE Platform](https://olive.kakao.com/)에서 확인할 수 있습니다.<br>OLIVE Platform에 프로젝트 생성은 최대 5개까지 가능합니다. | `false` |

### 입력값 설정 변경하기 

```yaml
- name: Run OLIVE CLI Scanner with custom settings
  uses: kakao/olive-actions@v1
  with:
    olive-project-name: "my-custom-project"
    olive-token: ${{ secrets.OLIVE_TOKEN }}
    github-token: ${{ secrets.GITHUB_TOKEN }}
    source-path: "./src"  # 분석할 소스코드 경로
    artifact-retention-days: "7"  # 아티팩트 보관 기간 (일)
    comment-on-pr: "true"  # PR에 코멘트 작성 여부
```

### 분석만 수행하기 

```yaml
- name: Run OLIVE CLI Scanner (analysis only)
  uses: kakao/olive-actions@v1
  with:
    olive-token: ${{ secrets.OLIVE_TOKEN }}
    github-token: ${{ secrets.GITHUB_TOKEN }}
    analyze-only: "true"
```

### 사용자 정의 config 파일 사용하기

사용자 정의 Config 파일은 github project 내에 존재해야 합니다.  
아래 예시에서는 github project 최상단에 user-config.yaml 파일이 있는 상황입니다.

```yaml
- name: Run OLIVE CLI Scanner with custom config
  uses: kakao/olive-actions@v1
  with:
    olive-token: ${{ secrets.OLIVE_TOKEN }}
    github-token: ${{ secrets.GITHUB_TOKEN }}
    user-config-path: "./user-config.yaml"
```

사용자 정의 config 파일(user-config.yaml) 예시:

```yaml
isOpenSource: false  # 소스 코드 공개 여부 (기본값: false)
excludePaths:  # 분석에서 제외할 경로
  - "node_modules"
  - ".git"
  - "build"
analysisType: "PARSER"  # Gradle 빌드 분석 타입 (PARSER, BUILDER, 기본값: PARSER)
onlyDirect: false  # 간접의존성 분석 결과 포함 여부 (기본값: false)
gradleBuildVariant: ""  # Gradle 빌드 변형 (예: "debug", "release", "")
excludeGradle:  # Gradle 빌드 수행시 제외할 모듈 이름
  - ":app"
```

## Actions 실행 결과

이 액션은 다음과 같은 아티팩트를 생성합니다:

- **local-config.yaml**: OLIVE CLI 설정 파일
- **dependency-analysis**: 의존성 분석 결과
  - dependency.csv: CSV 형식의 의존성 목록
  - dependency.json: JSON 형식의 의존성 상세 정보
- **apply-analysis**: 적용 분석 결과
  - dependency.csv: CSV 형식의 적용 의존성 목록
  - dependency.json: JSON 형식의 적용 의존성 상세 정보
  - mapping.csv: CSV 형식의 적용 매핑 목록
  - mapping.json: JSON 형식의 적용 매핑 상세 정보
  - unmapping.csv: CSV 형식의 언매핑 목록

## PR 코멘트

PR에 자동으로 생성되는 코멘트는 다음 정보를 포함합니다:

- OLIVE CLI 버전
- 프로젝트 이름
- 상세 로그 링크
- 라이선스 정보
- 컴포넌트 매핑 정보
- 언매핑 의존성 정보
- 생성된 아티팩트 목록 (테이블 형식)

기존 코멘트가 있는 경우 업데이트되며, 없는 경우 새로 생성됩니다.

## 참고사항

- 이 액션은 github.com에 정의된 github action 정책을 따릅니다.
- 이 액션은 Docker가 실행 가능한 러너에서 실행되어야 합니다
- OLIVE API 토큰이 유효해야 합니다. [토큰 사용하기 안내 참고](https://olive.kakao.com/docs/my-page/token)
- 액션이 실패한 경우 다음의 [GITHUB ACTION 실패 가이드](https://olive.kakao.com//docs/cli/github-actions-error)를 참고하여 문제를 해결할 수 있습니다.

## License

This software is licensed under the Apache 2 license, quoted below.

Copyright 2025 Kakao Corp. http://www.kakaocorp.com

Licensed under the Apache License, Version 2.0 (the "License"); you may not use this project except in compliance with the License. You may obtain a copy of the License at http://www.apache.org/licenses/LICENSE-2.0.

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.
