// Populate the sidebar
//
// This is a script, and not included directly in the page, to control the total size of the book.
// The TOC contains an entry for each page, so if each page includes a copy of the TOC,
// the total size of the page becomes O(n**2).
class MDBookSidebarScrollbox extends HTMLElement {
    constructor() {
        super();
    }
    connectedCallback() {
        this.innerHTML = '<ol class="chapter"><li class="chapter-item expanded affix "><li class="part-title">Welcome</li><li class="chapter-item expanded "><a href="intro.html"><strong aria-hidden="true">1.</strong> Introduction</a></li><li class="chapter-item expanded "><a href="quick-start.html"><strong aria-hidden="true">2.</strong> Quick start</a></li><li class="chapter-item expanded "><a href="generating-images.html"><strong aria-hidden="true">3.</strong> Generating images</a></li><li class="chapter-item expanded "><a href="installer.html"><strong aria-hidden="true">4.</strong> Installer</a></li><li><ol class="section"><li class="chapter-item expanded "><a href="installer/script.html"><strong aria-hidden="true">4.1.</strong> Inspect the code</a></li></ol></li><li class="chapter-item expanded "><li class="part-title">Modules</li><li class="chapter-item expanded "><a href="modules/apps.html"><strong aria-hidden="true">5.</strong> apps</a></li><li class="chapter-item expanded "><a href="modules/boot.html"><strong aria-hidden="true">6.</strong> boot</a></li><li class="chapter-item expanded "><a href="modules/common.html"><strong aria-hidden="true">7.</strong> common</a></li><li class="chapter-item expanded "><a href="modules/desktops.html"><strong aria-hidden="true">8.</strong> desktops</a></li><li class="chapter-item expanded "><a href="modules/deterministic-ids.html"><strong aria-hidden="true">9.</strong> deterministic-ids</a></li><li class="chapter-item expanded "><a href="modules/development.html"><strong aria-hidden="true">10.</strong> development</a></li><li class="chapter-item expanded "><a href="modules/compose-runner.html"><strong aria-hidden="true">11.</strong> compose-runner</a></li><li class="chapter-item expanded "><a href="modules/gaming.html"><strong aria-hidden="true">12.</strong> gaming</a></li><li class="chapter-item expanded "><a href="modules/hardening.html"><strong aria-hidden="true">13.</strong> hardening</a></li><li class="chapter-item expanded "><a href="modules/impermanence.html"><strong aria-hidden="true">14.</strong> impermanence</a></li><li class="chapter-item expanded "><a href="modules/locales.html"><strong aria-hidden="true">15.</strong> locales</a></li><li class="chapter-item expanded "><a href="modules/msmtp.html"><strong aria-hidden="true">16.</strong> msmtp</a></li><li class="chapter-item expanded "><a href="modules/networking.html"><strong aria-hidden="true">17.</strong> networking</a></li><li class="chapter-item expanded "><a href="modules/nix.html"><strong aria-hidden="true">18.</strong> nix</a></li><li class="chapter-item expanded "><a href="modules/oci.html"><strong aria-hidden="true">19.</strong> oci</a></li><li class="chapter-item expanded "><a href="modules/servers.html"><strong aria-hidden="true">20.</strong> servers</a></li><li class="chapter-item expanded "><a href="modules/shells.html"><strong aria-hidden="true">21.</strong> shells</a></li><li class="chapter-item expanded "><a href="modules/syncthing.html"><strong aria-hidden="true">22.</strong> syncthing</a></li><li class="chapter-item expanded "><a href="modules/tailscale-tls.html"><strong aria-hidden="true">23.</strong> tailscale-tls</a></li><li class="chapter-item expanded "><a href="modules/tailscale.html"><strong aria-hidden="true">24.</strong> tailscale</a></li><li class="chapter-item expanded "><a href="modules/users.html"><strong aria-hidden="true">25.</strong> users</a></li><li class="chapter-item expanded "><a href="modules/zfs.html"><strong aria-hidden="true">26.</strong> zfs</a></li><li class="chapter-item expanded affix "><li class="part-title">Misc</li><li class="chapter-item expanded "><a href="credits.html"><strong aria-hidden="true">27.</strong> Credits</a></li></ol>';
        // Set the current, active page, and reveal it if it's hidden
        let current_page = document.location.href.toString();
        if (current_page.endsWith("/")) {
            current_page += "index.html";
        }
        var links = Array.prototype.slice.call(this.querySelectorAll("a"));
        var l = links.length;
        for (var i = 0; i < l; ++i) {
            var link = links[i];
            var href = link.getAttribute("href");
            if (href && !href.startsWith("#") && !/^(?:[a-z+]+:)?\/\//.test(href)) {
                link.href = path_to_root + href;
            }
            // The "index" page is supposed to alias the first chapter in the book.
            if (link.href === current_page || (i === 0 && path_to_root === "" && current_page.endsWith("/index.html"))) {
                link.classList.add("active");
                var parent = link.parentElement;
                if (parent && parent.classList.contains("chapter-item")) {
                    parent.classList.add("expanded");
                }
                while (parent) {
                    if (parent.tagName === "LI" && parent.previousElementSibling) {
                        if (parent.previousElementSibling.classList.contains("chapter-item")) {
                            parent.previousElementSibling.classList.add("expanded");
                        }
                    }
                    parent = parent.parentElement;
                }
            }
        }
        // Track and set sidebar scroll position
        this.addEventListener('click', function(e) {
            if (e.target.tagName === 'A') {
                sessionStorage.setItem('sidebar-scroll', this.scrollTop);
            }
        }, { passive: true });
        var sidebarScrollTop = sessionStorage.getItem('sidebar-scroll');
        sessionStorage.removeItem('sidebar-scroll');
        if (sidebarScrollTop) {
            // preserve sidebar scroll position when navigating via links within sidebar
            this.scrollTop = sidebarScrollTop;
        } else {
            // scroll sidebar to current active section when navigating via "next/previous chapter" buttons
            var activeSection = document.querySelector('#sidebar .active');
            if (activeSection) {
                activeSection.scrollIntoView({ block: 'center' });
            }
        }
        // Toggle buttons
        var sidebarAnchorToggles = document.querySelectorAll('#sidebar a.toggle');
        function toggleSection(ev) {
            ev.currentTarget.parentElement.classList.toggle('expanded');
        }
        Array.from(sidebarAnchorToggles).forEach(function (el) {
            el.addEventListener('click', toggleSection);
        });
    }
}
window.customElements.define("mdbook-sidebar-scrollbox", MDBookSidebarScrollbox);
