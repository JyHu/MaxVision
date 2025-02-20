const Page = {
    Index: 'index',
    Privacy: 'privacy'
};

const Languages = {
    'zh-hans': '简体中文',
    'zh-hant': '繁体中文',
    'en': 'English',
    'es': 'Español',
    'fr': 'Français',
    'de': 'Deutsch',
    'ru': 'русский',
    'ja': '日本語',
    'ko': '한국어',
    'pt': 'Português',
    'it': 'Italiano',
    'th': 'ไทย'
};

const i18n = {
    'zh-hans': {
        appName: '超视觉',
        home: '首页',
        privacy: '隐私',
        // ... 其他翻译内容
    },
    'zh-hant': {
        appName: '超視覺',
        home: '首頁',
        privacy: '隱私',
        // ... 其他翻译内容
    },
    'en': {
        appName: 'Max Vision',
        home: 'Home',
        privacy: 'Privacy',
        // ... 其他翻译内容
    },
    'es': {
        appName: 'Max Visión',
        home: 'Inicio',
        privacy: 'Privacidad',
        // ... 其他翻译内容
    },
    'fr': {
        appName: 'Max Vision',
        home: 'Accueil',
        privacy: 'Confidentialité',
        // ... 其他翻译内容
    },
    'de': {
        appName: 'Max Vision',
        home: 'Startseite',
        privacy: 'Datenschutz',
        // ... 其他翻译内容
    },
    'ru': {
        appName: 'Max Vision',
        home: 'Главная',
        privacy: 'Конфиденциальность',
        // ... 其他翻译内容
    },
    'ja': {
        appName: 'Max Vision',
        home: 'ホーム',
        privacy: 'プライバシー',
        // ... 其他翻译内容
    },
    'ko': {
        appName: 'Max Vision',
        home: '홈',
        privacy: '개인정보 처리방침',
        // ... 其他翻译内容
    },
    'pt': {
        appName: 'Max Vision',
        home: 'Início',
        privacy: 'Privacidade',
        // ... 其他翻译内容
    },
    'it': {
        appName: 'Max Vision',
        home: 'Home',
        privacy: 'Privacy',
        // ... 其他翻译内容
    },
    'th': {
        appName: 'Max Vision',
        home: 'หน้าแรก',
        privacy: 'ความเป็นส่วนตัว',
        // ... 其他翻译内容
    }
};

function getCurrentLanguage() {
    return localStorage.getItem('language') || 'zh-hans';
}

function getCurrentAppName() {
    const lang = getCurrentLanguage();
    return i18n[lang].appName;
}

window.t = function(key) {
    const lang = getCurrentLanguage();
    return i18n[lang][key];
};

function renderHTML(page, pageContent) {
    const html = `
        <main>
            <header>
                <div class="header-content">
                    <div class="header-left">
                        <h1>${t("appName")}</h1>
                        <div class="tabs">
                            <a href="index.html" class="${page === Page.Index ? 'active' : ''}">${t('home')}</a>
                            <span>/</span>
                            <a href="privacy.html" class="${page === Page.Privacy ? 'active' : ''}">${t('privacy')}</a>
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
                <span>•</span>
                <div class="language-selector">
                    <button id="langBtn" onclick="toggleLanguageMenu()">${Languages[getCurrentLanguage()]}</button>
                    <div id="langMenu" class="language-menu">
                        ${Object.entries(Languages).map(([code, name]) => `
                            <a href="#" onclick="changeLanguage('${code}')" class="${code === getCurrentLanguage() ? 'active' : ''}">${name}</a>
                        `).join('')}
                    </div>
                </div>
            </div>
        </footer>`;

    document.getElementById('app').innerHTML = html;
    document.getElementById('markdown-content').innerHTML = marked.parse(pageContent);
}

function toggleLanguageMenu() {
    const menu = document.getElementById('langMenu');
    menu.classList.toggle('show');
}

function changeLanguage(lang) {
    localStorage.setItem('language', lang);
    location.reload(); // 重新加载页面以应用新语言
}