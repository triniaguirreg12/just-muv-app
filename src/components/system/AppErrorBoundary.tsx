import React from "react";
import { Button } from "@/components/ui/button";

type Props = {
  children: React.ReactNode;
};

type State = {
  error?: Error;
};

export class AppErrorBoundary extends React.Component<Props, State> {
  state: State = {};

  static getDerivedStateFromError(error: Error): State {
    return { error };
  }

  componentDidCatch(error: Error) {
    // Keep this log: it helps debug blank screens in production builds.
    // eslint-disable-next-line no-console
    console.error("App crashed:", error);
  }

  render() {
    if (!this.state.error) return this.props.children;

    return (
      <div className="min-h-screen bg-background text-foreground flex items-center justify-center p-6">
        <main className="w-full max-w-xl rounded-2xl border border-border bg-card p-6">
          <header className="space-y-1">
            <h1 className="text-lg font-semibold">No se pudo cargar la app</h1>
            <p className="text-sm text-muted-foreground">
              Se produjo un error en el render. Abajo tienes el mensaje para poder corregirlo.
            </p>
          </header>

          <section className="mt-4">
            <div className="rounded-xl border border-border bg-background/40 p-3">
              <p className="text-sm font-medium">Error</p>
              <pre className="mt-2 whitespace-pre-wrap break-words text-xs text-muted-foreground">
                {this.state.error.message}
              </pre>
            </div>

            <div className="mt-4 flex flex-wrap gap-2">
              <Button onClick={() => window.location.reload()}>Recargar</Button>
              <Button variant="secondary" onClick={() => (window.location.href = "/login")}
              >
                Ir a Login
              </Button>
            </div>
          </section>
        </main>
      </div>
    );
  }
}
