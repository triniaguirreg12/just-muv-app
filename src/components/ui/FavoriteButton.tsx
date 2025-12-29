import { Heart } from "lucide-react";
import { cn } from "@/lib/utils";
import { useIsFavorite, useToggleFavorite } from "@/hooks/useFavorites";
import { useAuth } from "@/hooks/useAuth";

interface FavoriteButtonProps {
  routineId: string;
  className?: string;
  size?: "sm" | "md";
  variant?: "default" | "overlay";
}

export function FavoriteButton({ routineId, className, size = "md", variant = "default" }: FavoriteButtonProps) {
  const { user } = useAuth();
  const { data: isFavorite = false } = useIsFavorite(routineId);
  const toggleFavorite = useToggleFavorite();

  if (!user) return null;

  const handleClick = (e: React.MouseEvent) => {
    e.preventDefault();
    e.stopPropagation();
    toggleFavorite.mutate({ routineId, isFavorite });
  };

  const sizeClasses = size === "sm" ? "h-6 w-6" : "h-8 w-8";
  const iconSize = size === "sm" ? "h-3.5 w-3.5" : "h-4 w-4";

  return (
    <button
      onClick={handleClick}
      className={cn(
        "rounded-full flex items-center justify-center transition-all hover:scale-110",
        variant === "overlay" ? "bg-black/40 backdrop-blur-sm" : "bg-transparent",
        sizeClasses,
        className
      )}
      disabled={toggleFavorite.isPending}
    >
      <Heart
        className={cn(
          iconSize,
          "transition-colors",
          isFavorite ? "text-destructive fill-destructive" : "text-white"
        )}
      />
    </button>
  );
}
