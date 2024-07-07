// Terragrunt에서의 모듈 변경 //
참고 url : https://www.maxivanov.io/how-to-move-resources-and-modules-in-terragrunt/
* EX *

- pwd 
    {프로젝트명}/ap-northeast-2/vpc

- vpc 리소스를 정의한 terragrunt.hcl 코드의 모듈 source 경로가 아래와 같다.
    terraform {
        source = "/module/vpc/ver_1.0.0"
    }

- 현재 ver_1.0.0 vpc 모듈을 사용중이며, 모듈 업데이트가 발생하여 ver_1.0.1가 생성되었다.

- 위 코드를 아래와 같이 변경한다
    terraform {
        source = "/module/vpc/ver_1.0.1"
    }

- tfstate 파일 백업
    terragrunt state pull > /backup/{프로젝트명}-ap-northeast-2-vpc-backup.tfstate
    -  위 명령은 백업하고자하는 리소스 경로에서 실행한다.
        ㄴ 예를들어 ec2 인스턴스의 state를 백업하고자한다면, 
        /Users/hann/hann_lab/terrform_labs/terragrunt_labs/terragrunt_lab/lab_01/infra_01/ap-northeast-2/ec2_instance
        그리고 백업하고자하는 경로를 정의하는 것. 
        /backup/{프로젝트명}-ap-northeast-2-vpc-backup.tfstate
        *추가*
            백업할 경로(dir)는 미리 생성되어있어야 한다.
    -  Terraform은 terraform state * 명령을 사용하여 모든 tfstate의 백업 파일을 생성하지만
       원격 백엔드에 있는 경우 자동으로 tfstate를 백업하지 않는다.
    - tfstate 파일은 리소스를 정의한 terragrunt.hcl 파일과 같은 경로에 있는 
      .terragrunt-cache -> {랜덤값 폴더} -> {랜덤값 폴더} -> {프로젝트명} -> 이후 최 하위 폴더에 있다.

- 아래 명령을 순서대로 실행하여 tfstate 파일을 push 후 변경사항(No changes)를 확인한다. (init 필수)
    terragrunt init
    terragrunt state push /backup/{프로젝트명}-ap-northeast-2-vpc-backup.tfstate
    terragrunt plan


// 다음 명령은 명령어를 실행하는 위치에서 현재 경로를 기준으로 하위의 모든 곳에서 cache 또는 lock.hcl을 삭제하는 명령이다.
find . -name '.terragrunt-cache' -type d -exec rm -rf {} +
find . -name '.terraform.lock.hcl' -type f -exec rm -rf {} +


// 모듈 변경 작업 전체적인 과정
    //모듈 버전을 변경하고자하는 리소스 dir로 이동
    cd /Users/hann/hann_lab/terrform_labs/terragrunt_labs/terragrunt_lab/lab_01/infra_01/ap-northeast-2/vpc
    //state 파일 백업
    tg state pull > /Users/hann/hann_lab/terrform_labs/terragrunt_labs/terragrunt_lab/lab_01/state_backup/infra_01-ap-northeast-2-vpc-backup.tfstate
    //기존 state 정보들 삭제
    find . -name '.terragrunt-cache' -type d -exec rm -rf {} +
    find . -name '.terraform.lock.hcl' -type f -exec rm -rf {} +
    // 여기서 리소스 코드상에서 모듈의 버전을 변경한다
    // 백업해둔 state파일 push 및 no change 검증
    tg init
    tg state push /Users/hann/hann_lab/terrform_labs/terragrunt_labs/terragrunt_lab/lab_01/state_backup/infra_01-ap-northeast-2-vpc-backup.tfstate
    tg apply -parallelism=5000
