[![Logo Image](https://i.imgur.com/rrp2f0j.png)](https://panel.pyro.host)

<p align="center">
 <a aria-label="Pyro logo" href="https://pyro.host"><img src="https://i.imgur.com/uvIy6cI.png"></a>
 <a aria-label="Join the Pyro community on Discord" href="https://discord.gg/fxeRFRbhQh?utm_source=githubreadme&utm_medium=readme&utm_campaign=OSSLAUNCH&utm_id=OSSLAUNCH"><img alt="" src="https://i.imgur.com/qSfKisV.png"></a>
 <a aria-label="Licensed under Business Source License 1.1" href="https://github.com/pyrohost/panel/blob/main/LICENSE"><img alt="" src="https://i.imgur.com/DHx8Cz6.png"></a>
</p>

<h1 align="center">pyrodactyl installation script</h1>

pyrodactyl is the Pterodactyl-based game server management panel that focuses on performance enhancements, a reimagined, accessible interface, and top-tier developer experience. Builds faster, compiles smaller: pyrodactyl is the world's best Pterodactyl.

[![Dashboard Image](https://pyro.host/img/panel1.jpg)](https://panel.pyro.host)

## Changes from vanilla Pterodactyl

-   **Smaller bundle sizes:** pyrodactyl is built using Vite, and significant re-architecting of the application means pyrodactyl's initial download size is over **[170 times smaller than leading, closed-source Pterodactyl forks](https://i.imgur.com/tKWLHhR.png)**
-   **Faster build times:** pyrodactyl completes builds in milliseconds with the power of Turbo. Cold builds with zero cache finish in **under 7 seconds**.
-   **Faster loading times:** pyrodactyl's load times are, on average, **[over 16 times faster](https://i.imgur.com/28XxmMi.png)** than other closed-source Pterodactyl forks. Smarter code splitting and chunking means that pages you visit in the panel only load necessary resources on demand. Better caching means that everything is simply _snappy_.
-   **More secure:** pyrodactyl's modern architecture means **most severe and easily exploitable CVEs simply do not exist**. We have also implemented SRI and integrity checks for production builds.
-   **More accessible:** Pyro believes that gaming should be easily available for everyone. pyrodactyl builds with the latest Web accessibility guidelines in mind. pyrodactyl is **entirely keyboard-navigable, even context menus.**, and screen-readers are easily compatible.
-   **More approachable:** pyrodactyl's friendly, approachable interface means that anyone can confidently run a game server [with Pyro](https://pyro.host).

[![Dashboard Image](https://pyro.host/img/panel3.jpg)](https://panel.pyro.host)

### Installing Pyrodactyl

```console
bash <(curl -s https://raw.githubusercontent.com/ManucrackYT/pyroactyl-installer/main/install.sh)
```

### Notes about Local Development

-   If you have the dev server running (`pnpm dev`), a development build of the app will be served at localhost:3000 with HMR. If you want to preview a production build of pyrodactyl, terminate the dev server and run `pnpm ship`. Once it finishes, it will also be served at localhost:3000.

-   If you're running the development server or have built a production version of pyrodactyl, but visiting localhost:3000 hangs permanently, ensure you don't have any other apps or games open that may interfere with any of the ports in the Vagrantfile. For example, Steam may use port 8080, or another development server may be using a port used by pyrodactyl. Run `vagrant reload` to re-point ports to your virtual machine after ensuring nothing may be using it, and try again.

-   If you receive a message like `Vagrant was unable to mount VirtualBox shared folders`, you [may need to install the vbguest plugin for VirtualBox](https://stackoverflow.com/a/48569055/11537010) with `vagrant plugin install vagrant-vbguest`. If it's already installed, run `vagrant plugin update vagrant-vbguest`.

-   We recommend setting up [Remote Caching via turbo](https://turbo.build/repo/docs/core-concepts/remote-caching). When you run `pnpm ship` on your local development machine, its results will be cached and uploaded, allowing you to finish a build on your production server in milliseconds.

## Star History

<a href="https://star-history.com/#pyrohost/panel&Date">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="https://api.star-history.com/svg?repos=pyrohost/panel&type=Date&theme=dark" />
    <source media="(prefers-color-scheme: light)" srcset="https://api.star-history.com/svg?repos=pyrohost/panel&type=Date" />
    <img alt="Star History Chart" src="https://api.star-history.com/svg?repos=pyrohost/panel&type=Date" />
  </picture>
</a>

## License

Pterodactyl® Copyright © 2015 - 2022 Dane Everitt and contributors.

pyrodactyl™ Copyright © 2024 pyro.host

pyrodactyl™ and its source code is licensed and distributed under Business Source License 1.1. Please see the [LICENSE](https://github.com/pyrohost/panel/blob/main/LICENSE) file for more information on your rights to use pyrodactyl.
