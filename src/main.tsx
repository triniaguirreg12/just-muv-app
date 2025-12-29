import "./index.css";

import { createRoot } from "react-dom/client";

function renderFatal(error: unknown) {
  const message = error instanceof Error ? error.message : String(error);
  const rootEl = document.getElementById("root");
  if (!rootEl) return;

  rootEl.innerHTML = `
    <div style="min-height:100vh;display:flex;align-items:center;justify-content:center;padding:24px;">
      <main style="max-width:720px;width:100%;border:1px solid hsl(192 30% 20%);background:hsl(192 40% 12%);border-radius:16px;padding:20px;font-family:Poppins,system-ui,-apple-system,Segoe UI,Roboto,sans-serif;color:hsl(180 20% 95%);">
        <h1 style="margin:0 0 6px;font-size:18px;">No se pudo cargar la app</h1>
        <p style="margin:0 0 12px;font-size:13px;color:hsl(180 15% 55%);">Se detectó un error antes de renderizar React.</p>
        <pre style="white-space:pre-wrap;word-break:break-word;background:rgba(0,0,0,0.25);padding:12px;border-radius:12px;border:1px solid hsl(192 30% 20%);font-size:12px;color:hsl(180 20% 95%);">${message}</pre>
      </main>
    </div>
  `;
}

(async () => {
  try {
    const [{ default: App }, React] = await Promise.all([import("./App"), import("react")]);

    const rootEl = document.getElementById("root");
    if (!rootEl) throw new Error("Missing #root element");

    createRoot(rootEl).render(React.createElement(App));
  } catch (e) {
    // eslint-disable-next-line no-console
    console.error("Bootstrap error:", e);
    renderFatal(e);
  }
})();

