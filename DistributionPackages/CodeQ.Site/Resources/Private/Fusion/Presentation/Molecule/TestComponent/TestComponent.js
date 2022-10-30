export default class TestComponent {
    static init() {
        Array.from(document.querySelectorAll('.test-component')).forEach(element => {
            new TestComponent(element);
        });
    }

    classes = {
        node: 'test-component'
    }

    constructor(element) {
        if (!element) return;

    }
}
	