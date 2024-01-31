FROM mcr.microsoft.com/playwright:v1.41.1-jammy

# Avoid prompts for time zone
ENV DEBIAN_FRONTEND noninteractive
ENV TZ=America/New_York

# Install TigerVNC, X11, and other necessary packages
RUN apt update && apt install -y \
    tigervnc-standalone-server \
    tigervnc-common \
    xterm \
    fluxbox \
    net-tools \
    novnc \
    python3 \
    python3-pip \
    && rm -rf /var/lib/apt/lists/*

# Set environment variables for VNC
ENV DISPLAY=:1 \
    VNC_PORT=5901 \
    NOVNC_PORT=6080 \
    VNC_RESOLUTION=1280x800 \
    VNC_COL_DEPTH=24
    # VNC_PASSWORD=password

# Expose VNC and noVNC ports
EXPOSE $VNC_PORT $NOVNC_PORT

# Set up VNC password
# RUN mkdir ~/.vnc && \
    # echo $VNC_PASSWORD | vncpasswd -f > ~/.vnc/passwd && \
    # chmod 600 ~/.vnc/passwd

# Configure noVNC
RUN ln -s /usr/share/novnc/vnc.html /usr/share/novnc/index.html

# Copy a script to start VNC and noVNC
COPY start.sh /start.sh
RUN chmod +x /start.sh

COPY . /app
WORKDIR /app

RUN pip install playwright && playwright install

CMD ["/start.sh"]
