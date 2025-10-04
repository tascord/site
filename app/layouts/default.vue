<style>
@import '~/css/main.css';

body {
    overflow-x: hidden;
}
</style>

<template>
    <div
        class="w-screen min-h-screen flex flex-col bg-black flex items-center justify-center overflow-none blur-[0.6px]">
        <img class="fixed bottom-0 left-0 w-screen h-screen mix-blend-screen opacity-20 select-none pointer-events-none"
            src="https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fstatic.vecteezy.com%2Fsystem%2Fresources%2Fpreviews%2F004%2F681%2F592%2Flarge_2x%2Fdirt-overlay-screen-effect-use-for-grunge-background-and-vintage-style-abstract-dust-particle-and-dust-grain-texture-on-black-background-free-photo.jpg&f=1&nofb=1&ipt=9c67d0dca3a873bc5b52ed0a7f382553e74f55074b063fe1d282f7f293dc4162"
            alt="" aria-hidden="true">

        <div class="h-full flex-1 w-full max-w-[50rem]">
            <Header />
            <slot />
        </div>

        <footer class="flex flex-col items-center justify-center space-y-4 text-white h-20">
            <span>EOF</span>
            <span>&copy; flora, {{ new Date().getFullYear() }}</span>
        </footer>
    </div>
</template>