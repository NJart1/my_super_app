/*
This file was generated by the Surface compiler.
*/

import { createPopper } from '@popperjs/core';

export default {
    updated() {
        const trigger = this.el.children[0];
        const tooltip = this.el.children[1];

        tooltip && createPopper(trigger, tooltip, {
            placement: this.el.dataset.placement || 'bottom-start',
            strategy: 'fixed',
            modifiers: [
                {
                    name: 'offset',
                    options: {
                        offset: [0, 8],
                    },
                },
            ],
        });
    }
}
