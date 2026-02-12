<script lang="ts">
	import { getContext, onMount } from 'svelte';
	import Modal from '../common/Modal.svelte';
	import { shortcuts } from '$lib/shortcuts';
	import { settings } from '$lib/stores';
	import ShortcutItem from './ShortcutItem.svelte';
	import XMark from '$lib/components/icons/XMark.svelte';

	type CategorizedShortcuts = {
		[category: string]: {
			left: Shortcut[];
			right: Shortcut[];
		};
	};

	const i18n = getContext('i18n');

	export let show = false;

	let categorizedShortcuts: CategorizedShortcuts = {};
	let isMac = false;

	onMount(() => {
		isMac = /Mac/i.test(navigator.userAgent);
	});

	$: {
		const allShortcuts = Object.values(shortcuts).filter((shortcut) => {
			if (!shortcut.setting) {
				return true;
			}
			return $settings[shortcut.setting.id] === shortcut.setting.value;
		});

		categorizedShortcuts = allShortcuts.reduce((acc, shortcut) => {
			const category = shortcut.category;
			if (!acc[category]) {
				acc[category] = [];
			}
			acc[category].push(shortcut);
			return acc;
		}, {});
	}
</script>

<Modal bind:show>
	<div class="text-gray-700 dark:text-gray-100 px-5 py-4">
		<div class="flex justify-between dark:text-gray-300 pb-2">
			<div class="text-lg font-medium self-center">TDX Attestation Result</div>
			<button class="self-center" on:click={() => (show = false)}>
				<XMark className={'size-5'} />
			</button>
		</div>

		<p>
			Confidential Computing<br/>
			Intel® TDX enabled - Hardware-level protection <span style="color: darkgreen">active</span>
		</p>

		<table style="margin-top: 30px;width:100%;table-layout:fixed">
			<tbody>
			<tr>
				<td>
					<small>TD Status</small>
					<div>Online</div>
					<small>Status: healthy</small>
				</td>
				<td style="width:20%"></td>
				<td>
					<small>GPU</small><br/>
					<strong>NVIDIA H100 PCIe</strong>
				</td>
			</tr>
			</tbody>
		</table>





			<div class="py-3">
				<div class="w-full border-t dark:border-gray-850 border-gray-50" />
			</div>

		Token details
	</div>
</Modal>

<style>
	input::-webkit-outer-spin-button,
	input::-webkit-inner-spin-button {
		-webkit-appearance: none;
		margin: 0;
	}

	.tabs::-webkit-scrollbar {
		display: none;
	}

	.tabs {
		-ms-overflow-style: none;
		scrollbar-width: none;
	}

	input[type='number'] {
		-moz-appearance: textfield;
	}
</style>
