SOURCE= "${BASH_SOURCE}"
nvidia-docker run -ti --runtime=nvidia -e NVIDIA_DRIVER_CAPABILITIES=compute,utility -e NVIDIA_VISIBLE_DEVICES=all \
	      -v $(cd "$(dirname "$SOURCE")"/.. && pwd):/root/projects/pytorch_fnet \
	      ${USER}/pytorch_fnet \
	      bash

