SHELL=bash
.PHONY: Ascend.install

Ascend.install: Ascend-cann-toolkit_8.3.RC1.alpha002_linux-aarch64.run python.dep
	chmod +x $<
	./$< --install && touch $@

# 8.2.RC2 cannot support python3.12
Ascend-cann-toolkit_8.3.RC1.alpha002_linux-aarch64.run:
	#curl -L -o $@ 'https://ascend-repo.obs.cn-east-2.myhuaweicloud.com/CANN/CANN%208.2.RC2/Ascend-cann-toolkit_8.2.RC2_linux-aarch64.run?response-content-type=application/octet-stream'
	curl -L -o $@ 'https://ascend-repo.obs.cn-east-2.myhuaweicloud.com/Milan-ASL/Milan-ASL%20V100R001C23B800TP004/Ascend-cann-toolkit_8.3.RC1.alpha002_linux-aarch64.run?response-content-type=application/octet-stream'

python_pkg=attrs cython numpy decorator sympy cffi pyyaml pathlib2 psutil protobuf scipy requests absl-py

python.dep: $(python_pkg:%=dep/%.install)
	touch $@
dep/%.install:
	mkdir -p $(@D)
	if pip3 show $* &>/dev/null; then echo "$* already install" && touch $@; else echo "try to install $*"; if sudo apt install -y python3-$* ; then touch $@ && echo "apt install $*"; else if pip3 install $* --user --break-system-package -i https://pypi.tuna.tsinghua.edu.cn/simple; then touch $@ && echo "pip3 install $*, which is a non-system package"; fi; fi; fi;

Miniconda.install: Miniconda3-latest-Linux-aarch64.sh
	mkdir -p ~/miniconda3
	bash ./$< -b -u -p ~/miniconda3
Miniconda3-latest-Linux-aarch64.sh:
	wget https://mirrors.tuna.tsinghua.edu.cn/anaconda/miniconda/$@ -O $@
.SECONDARY:
.DELETE_ON_ERROR:
