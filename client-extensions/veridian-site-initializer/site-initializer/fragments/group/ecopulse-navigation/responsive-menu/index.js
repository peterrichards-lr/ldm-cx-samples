const toggle = fragmentElement.querySelector('.eco-menu-toggle');
const menu = fragmentElement.querySelector('.eco-mobile-menu');

if (toggle && menu) {
	toggle.addEventListener('click', () => {
		const isHidden = menu.hasAttribute('hidden');

		if (isHidden) {
			menu.removeAttribute('hidden');
			toggle.classList.add('active');
		} else {
			menu.setAttribute('hidden', '');
			toggle.classList.remove('active');
		}
	});
}
