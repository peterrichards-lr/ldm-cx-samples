class SampleCustomElement extends HTMLElement {
  connectedCallback() {
    const liferayInfo = window.Liferay ? 
      `<p>Liferay version: ${window.Liferay.PropsValues.LIFERAY_JS_VERSION || 'detected'}</p>` : 
      '<p>Liferay object not found (running outside Liferay?).</p>';

    this.innerHTML = `
      <div class="sample-container">
        <h1>Hello from LDM Sample Custom Element!</h1>
        <p>This is a static client extension served from the Liferay instance.</p>
        <div class="liferay-info">
          ${liferayInfo}
        </div>
        <button id="click-me">Click for Interaction</button>
        <div id="message" style="margin-top: 10px;"></div>
      </div>
    `;

    this.querySelector('#click-me').addEventListener('click', () => {
      this.querySelector('#message').innerText = 'You clicked the button! This is a simple interactive custom element.';
    });
  }
}

if (!customElements.get('sample-custom-element')) {
  customElements.define('sample-custom-element', SampleCustomElement);
}
