import type { Metadata } from "next";
import SearchClient from "./SearchClient";

export const metadata: Metadata = {
  title: "Tìm kiếm phim",
  description: "Tìm kiếm phim theo từ khoá, thể loại, quốc gia, năm tại Nô Lệ Làm Phim.",
};

export default async function SearchPage({
  searchParams,
}: {
  searchParams: Promise<{ q?: string }>;
}) {
  const { q } = await searchParams;
  return <SearchClient key={q ?? ""} initialQuery={q ?? ""} />;
}
