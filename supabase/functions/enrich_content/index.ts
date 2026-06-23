import "@supabase/functions-js/edge-runtime.d.ts";

interface EnrichRequest {
  type: "mythology" | "cuisine" | "clothes";
  name: string;
  baseDescription: string;
}

const SYSTEM_PROMPTS: Record<string, string> = {
  mythology: `You are a storyteller expert in Jharkhand's mythology, folklore, and legends.
Transform the given place description into a rich, narrative mythological story.

Respond with STRICT JSON (no markdown, no code fences) with this exact structure:
{
  "title": "string — captivating story title",
  "subtitle": "string — one-line hook",
  "summary": "string — 2-3 sentence overview of the legend",
  "legend": "string — the full mythological story in narrative form (3-5 paragraphs)",
  "culturalSignificance": "string — why this place matters in Jharkhand's culture",
  "keyCharacters": ["string — names of deities/figures involved"],
  "relatedPlaces": ["string — nearby places with connected legends"],
  "interestingFacts": ["string — 3-5 fascinating facts"],
  "moralOrTeaching": "string — the lesson or belief behind the legend"
}`,

  cuisine: `You are a food historian specializing in Jharkhand's traditional cuisine.
Transform the given food description into a rich, cultural story.

Respond with STRICT JSON (no markdown, no code fences) with this exact structure:
{
  "title": "string — enticing dish name as title",
  "subtitle": "string — one-line description of what makes it special",
  "originStory": "string — the history/origin of this dish (2-3 paragraphs)",
  "ingredients": ["string — key ingredients"],
  "preparationMethod": "string — how it's traditionally prepared (step-by-step narrative)",
  "culturalSignificance": "string — role of this dish in festivals/daily life",
  "whenEaten": "string — specific occasions, seasons, or times it's consumed",
  "interestingFacts": ["string — 3-5 unique facts"],
  "nutritionalValue": "string — traditional wisdom about its health benefits"
}`,

  clothes: `You are a textile historian and cultural expert on Jharkhand's traditional attire.
Transform the given clothing description into a rich, cultural story.

Respond with STRICT JSON (no markdown, no code fences) with this exact structure:
{
  "title": "string — evocative title for the attire",
  "subtitle": "string — one-line hook about its beauty/heritage",
  "originHistory": "string — historical background and evolution (2-3 paragraphs)",
  "materials": ["string — fabrics, threads, dyes used"],
  "craftsmanship": "string — weaving techniques, embroidery styles, artisan traditions",
  "culturalSignificance": "string — symbolic meaning in ceremonies and daily life",
  "occasionsWorn": ["string — festivals, weddings, rituals where it's worn"],
  "interestingFacts": ["string — 3-5 unique facts"],
  "modernRelevance": "string — how the attire is preserved and adapted today"
}`,
};

const corsHeaders = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
  "Access-Control-Allow-Headers": "Content-Type, Authorization",
};

Deno.serve(async (req) => {
  if (req.method === "OPTIONS") {
    return new Response(null, { status: 204, headers: corsHeaders });
  }

  if (req.method !== "POST") {
    return new Response(
      JSON.stringify({ success: false, error: "Method not allowed" }),
      { status: 405, headers: { ...corsHeaders, "Content-Type": "application/json" } },
    );
  }

  try {
    const { type, name, baseDescription } = await req.json() as EnrichRequest;

    if (!type || !["mythology", "cuisine", "clothes"].includes(type)) {
      return new Response(
        JSON.stringify({ success: false, error: "Invalid 'type'. Must be 'mythology', 'cuisine', or 'clothes'" }),
        { status: 400, headers: { ...corsHeaders, "Content-Type": "application/json" } },
      );
    }
    if (!name || typeof name !== "string") {
      return new Response(
        JSON.stringify({ success: false, error: "Missing or invalid 'name' (string required)" }),
        { status: 400, headers: { ...corsHeaders, "Content-Type": "application/json" } },
      );
    }
    if (!baseDescription || typeof baseDescription !== "string") {
      return new Response(
        JSON.stringify({ success: false, error: "Missing or invalid 'baseDescription' (string required)" }),
        { status: 400, headers: { ...corsHeaders, "Content-Type": "application/json" } },
      );
    }

    const apiKey = Deno.env.get("GROQ_API_KEY");
    if (!apiKey) {
      return new Response(
        JSON.stringify({ success: false, error: "GROQ_API_KEY not configured" }),
        { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } },
      );
    }

    const userPrompt = `Enrich this Jharkhand ${type} content into a captivating story:

Name: ${name}
Base Description: ${baseDescription}

Create an immersive, culturally accurate narrative that brings this to life.`;

    const response = await fetch("https://api.groq.com/openai/v1/chat/completions", {
      method: "POST",
      headers: {
        "Authorization": `Bearer ${apiKey}`,
        "Content-Type": "application/json",
      },
      body: JSON.stringify({
        model: "llama-3.3-70b-versatile",
        messages: [
          { role: "system", content: SYSTEM_PROMPTS[type] },
          { role: "user", content: userPrompt },
        ],
        response_format: { type: "json_object" },
        temperature: 0.8,
      }),
    });

    if (!response.ok) {
      const errorBody = await response.text();
      throw new Error(`Groq API error (${response.status}): ${errorBody}`);
    }

    const data = await response.json();
    const storyText = data.choices?.[0]?.message?.content;
    if (!storyText) {
      throw new Error("No response from Groq");
    }

    const story = JSON.parse(storyText);

    return new Response(
      JSON.stringify({ success: true, type, name, story }),
      { status: 200, headers: { ...corsHeaders, "Content-Type": "application/json" } },
    );
  } catch (error) {
    console.error("Enrich content error:", error);
    return new Response(
      JSON.stringify({
        success: false,
        error: error instanceof Error ? error.message : "Internal server error",
      }),
      { status: 500, headers: { ...corsHeaders, "Content-Type": "application/json" } },
    );
  }
});
