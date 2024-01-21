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
    -  Terraform은 terraform state * 명령을 사용하여 모든 tfstate의 백업 파일을 생성하지만
       원격 백엔드에 있는 경우 자동으로 tfstate를 백업하지 않는다.
    - tfstate 파일은 리소스를 정의한 terragrunt.hcl 파일과 같은 경로에 있는 
      .terragrunt-cache -> {랜덤값 폴더} -> {랜덤값 폴더} -> {프로젝트명} -> 이후 최 하위 폴더에 있다.

- 아래 명령을 순서대로 실행하여 tfstate 파일을 push 후 변경사항(No changes)를 확인한다. (init 필수)
    terragrunt init
    terragrunt state push /backup/{프로젝트명}-ap-northeast-2-vpc-backup.tfstate
    terragrunt plan
