FROM rocm/pytorch:rocm7.2.4_ubuntu22.04_py3.10_pytorch_release_2.10.0

# Install python (+ venv, due to PEP 0688 (https://peps.python.org/pep-0668/))
# Install adduser, so we can ensure there's a non-root user we can use
RUN apt update && \
    apt install --yes python3 python3-venv adduser

# Create a non-root user
RUN adduser --disabled-password --gecos "Default Jupyter user" \
    --uid 1000 \
     jovyan

# Create a venv to install packages into
RUN python3 -m venv /opt/venv

# "Activate" the venv, so `jupyterhub-singleuser` can be found when the container runs
ENV PATH /opt/venv/bin:${PATH}

# Install jupyterhub as well as at least one jupyter frontend
RUN /opt/venv/bin/pip install jupyterhub jupyterlab

# Run as the non-root user we just created
USER 1000

# Indicate what command we would like to be run to start this container image
CMD ["jupyterhub-singleuser"]
