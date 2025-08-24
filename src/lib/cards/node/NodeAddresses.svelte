<script lang="ts">
	import CardListEntry from '../CardListEntry.svelte';
	import type { Node } from '$lib/common/types';
	import RawMdiRename from '~icons/mdi/rename';
	import RawMdiCheckCircleOutline from '~icons/mdi/check-circle-outline';
	import RawMdiCloseCircleOutline from '~icons/mdi/close-circle-outline';
	import { changeIp } from '$lib/common/api';
	import { toastError, focus } from '$lib/common/funcs';
	import { getToastStore } from '@skeletonlabs/skeleton';
	import { debug } from '$lib/common/debug';
	import { App } from '$lib/States.svelte';

	type NodeAddressesProps = {
		node: Node,
	}

	let { node }: NodeAddressesProps = $props()

	let showChangeIpArray = $state([false, false]);
	let disableChangeIpArray = $state([false, false]);

	const ToastStore = getToastStore();
</script>

<CardListEntry title="IP Addresses:" top>
	<div class="grid grid-cols-1">
			{#each node.ipAddresses as ipAddress, index}
				{#if showChangeIpArray[index]}
					<form>
						<div class="flex">
							<input
								id={`changeip-${node.id}`}
								class="input text-sm rounded-md py-0 pr-2"
								bind:value={node.ipAddresses[index]}
								disabled={disableChangeIpArray[index]}
								use:focus
							/>
							<button
								type="submit"
								class="btn-sm btn-icon-sm"
								disabled={disableChangeIpArray[index]}
								onclick={async (event?: Event) => {
									event?.preventDefault();
									disableChangeIpArray[index] = true;
									try {
										if(node.ipAddresses[index] === ''){
											toastError('Node ip must not be empty', ToastStore)
											return
										}
										const m = await changeIp(node, index);
										for (let i = 0; i < App.nodes.value.length; i++) {
											if (App.nodes.value[i].id == m.id) {
												App.nodes.value[i].givenName = m.givenName;
												break;
											}
										}
										showChangeIpArray[index] = false;
									} catch (error) {
										if (error instanceof Error) {
											toastError('', ToastStore, error);
										} else {
											debug(error);
										}
										focus(document.getElementById(`changeip-${node.id}`));
									} finally {
										disableChangeIpArray[index] = false;
									}
								}}
							>
								<RawMdiCheckCircleOutline />
							</button>
							<button
								type="button"
								class="btn-sm btn-icon-sm"
								disabled={disableChangeIpArray[index]}
								onclick={() => { showChangeIpArray[index] = false; }}
							>
								<RawMdiCloseCircleOutline />
							</button>
						</div>
					</form>
				{:else}
					<div>
						{ipAddress}
						<button
							class="btn-sm btn-icon-sm"
							onclick={() => {
								showChangeIpArray[index] = true;
							}}
						>
							<RawMdiRename />
						</button>
					</div>
				{/if}
			{/each}
	</div>
</CardListEntry>
