const Page = {
    Index: 'index',
    Privacy: 'privacy'
};

function renderHTML(page, pageContent) {
    const html = `
        <main>
            <header>
                <div class="header-content">
                    <div class="header-left">
                        <h1>Max Vision</h1>
                        <div class="tabs">
                            <a href="index.html" class="${page === Page.Index ? 'active' : ''}">首页</a>
                            <span>/</span>
                            <a href="privacy.html" class="${page === Page.Privacy ? 'active' : ''}">隐私</a>
                            <span>/</span>
                            <a href="https://apps.apple.com/cn/app/super-visual/id6742104980" target="_blank">App Store</a>
                        </div>
                    </div>
                    <img src="res/icon.png" alt="Max Vision Icon" class="header-icon">
                </div>
            </header>

            <div id="markdown-content"></div>
        </main>

        <footer>
            <p>© 2025 Jos</p>
            <span>•</span>
            <div class="footer-links">
                <a href="mailto:auu.aug@gmail.com">E-mail</a>
                <span>•</span>
                <a href="https://github.com/JyHu" target="_blank">GitHub</a>
            </div>
        </footer>`;

    document.getElementById('app').innerHTML = html;
    document.getElementById('markdown-content').innerHTML = marked.parse(pageContent);
}